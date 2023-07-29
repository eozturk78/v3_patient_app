import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:patient_app/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

import '../../apis/apis.dart';
import '../../shared/shared.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userNameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Shared sh = new Shared();
  Apis apis = new Apis();
  bool remeberMeState = false;
  bool check1 = false;
  bool check2 = false;
  bool isSendEP = false;
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  bool proceedLoginWithTouchId = false;
  @override
  void initState() {
    // TODO: implement initState
    checkRemeberMe();
    _getAvailableBiometrics();
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }

  checkRemeberMe() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("rememberMe") == true.toString()) {
      remeberMeState = true;
      userNameController.text = pref.getString("userName")!;
      passwordController.text = pref.getString("password")!;
    }
    setState(() {});
  }

  Future<bool> authenticateIsAvailable() async {
    try {
      final isAvailable = await auth.canCheckBiometrics;
      final isDeviceSupported = await auth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');

    setState(() async {
      if (authenticated) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        userNameController.text = pref.getString("userName")!;
        passwordController.text = pref.getString("password")!;
        onLogin();
      }
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    if (await authenticateIsAvailable()) {
      try {
        setState(() {
          _isAuthenticating = true;
          _authorized = 'Authenticating';
        });
        authenticated = await auth.authenticate(
          localizedReason:
              'Scan your fingerprint (or face or whatever) to authenticate',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
        setState(() {
          _isAuthenticating = false;
          _authorized = 'Authenticating';
        });
      } on PlatformException catch (e) {
        print(e);
        setState(() {
          _isAuthenticating = false;
          _authorized = 'Error - ${e.message}';
        });
        return;
      }
      if (!mounted) {
        return;
      }

      final String message = authenticated ? 'Authorized' : 'Not Authorized';
      setState(() async {
        _authorized = message;
        if (authenticated) {
          SharedPreferences pref = await SharedPreferences.getInstance();
          if (pref.getString("userName") == null ||
              pref.getString("password") == null) {
            proceedLoginWithTouchId = true;
          } else {
            userNameController.text = pref.getString("userName")!;
            passwordController.text = pref.getString("password")!;
            onLogin();
          }
        }
      });
    } else {
      setState(() {
        _authorized = "Biometrics authentication is not available!";
      });
    }
  }

  onLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (remeberMeState) {
      pref.setString("rememberMe", true.toString());
      pref.setString("userName", userNameController.text);
      pref.setString("password", passwordController.text);
    } else if (proceedLoginWithTouchId) {
      pref.setString("userName", userNameController.text);
      pref.setString("password", passwordController.text);
    } else {
      pref.remove("rememberMe");
    }
    setState(() {
      isSendEP = true;
    });
    await apis.login(userNameController.text, passwordController.text).then(
        (value) async {
      if (value != null) {
        pref.setString('token', value['token']);

        await apis.patientInfo().then((value) {
          setState(() {
            isSendEP = false;
          });
          var p = sh.getBaseName(value['links']['self']);
          pref.setString('patientId', '${p}');
          var patientGroups = value['patientGroups'];
          pref.setString(
              'patientTitle', '${value["firstName"]} ${value["lastName"]}');
          print(patientGroups);
          pref.setString("patientGroups", jsonEncode(patientGroups));
          Navigator.of(context).pushReplacementNamed("/main-menu");
        }, onError: (err) {
          setState(() {
            isSendEP = false;
          });
        });
      }
    }, onError: (err) {
      print(err);
      setState(() {
        isSendEP = false;
      });
    });
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Anmelden',
          style: TextStyle(color: Colors.black),
        ),
        shadowColor: null,
        elevation: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Image.asset(
                        "assets/images/logo-imedcom.png",
                        width: 200,
                        height: 100,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: userNameController,
                        obscureText: false,
                        decoration: const InputDecoration(
                          labelText: 'User name',
                        ),
                        validator: (text) => sh.textValidator(text),
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        validator: (text) => sh.textValidator(text),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: remeberMeState,
                            onChanged: ((value) => setState(() {
                                  remeberMeState = !remeberMeState;
                                })),
                          ),
                          Text("Remember me"),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(30),
                          primary: mainButtonColor,
                        ),
                        onPressed: () async {
                          final isValid = _formKey.currentState?.validate();
                          if (!isValid! || isSendEP) return;
                          onLogin();
                        },
                        child: !isSendEP
                            ? const Text("Send")
                            : Transform.scale(
                                scale: 0.5,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                )),
                      ),
                      if (_availableBiometrics != null &&
                          _availableBiometrics!.isNotEmpty)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            backgroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(30),
                            primary: mainButtonColor,
                          ),
                          onPressed: _authenticateWithBiometrics,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "Login mit touch ID",
                                style: TextStyle(color: mainButtonColor),
                              ),
                              const Icon(
                                Icons.fingerprint,
                                color: mainButtonColor,
                              ),
                            ],
                          ),
                        ),
                      if (proceedLoginWithTouchId)
                        Column(
                          children: [
                            Text(
                                "Bitte melden Sie sich zum ersten Mal an, um die Touch-ID-Anmeldung zu aktivieren")
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ),
            //SharedPreferences glopref =  SharedPreferences.getInstance()
          ]),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
