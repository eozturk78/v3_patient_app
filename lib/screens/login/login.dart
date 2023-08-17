import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
  String? deviceToken;
  @override
  void initState() {
    // TODO: implement initState
    FirebaseMessaging _firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    _firebaseMessaging.getToken().then((token) {
      if (token != null) deviceToken = token;
      print(deviceToken);
    });
    checkRememberMe();
    _getAvailableBiometrics();
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }

  checkRememberMe() async {
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
              'Scan your fingerprint (or face) to authenticate',
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
    bool result = await InternetConnectionChecker().hasConnection;
    if(result == true) {
      print('Has internet connection!');


    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("userName", userNameController.text);
    if (remeberMeState) {
      pref.setString("rememberMe", true.toString());
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

    await apis
        .login(userNameController.text, passwordController.text, deviceToken)
        .then((value) async {
      if (value != null) {
        // TODO: add else block to this if block
        setState(() {
          isSendEP = false;
        });
        print(value['firstName']);
        pref.setString("patientTitle", value['firstName']);
        pref.setString('token', value['token']);
        pref.setString('patientGroups', jsonEncode(value['token']));

        //isLoggedIn = true;
        //Navigator.of(context).pushReplacementNamed("/main-menu");
        checkRedirection();
      }
    }, onError: (err) {
      setState(() {
        isSendEP = false;
      });
      print(err);
      try {
        sh.redirectPatient(err, context);
      }
      catch(e){
          showToast(e.toString());
      }
    });

    } else {
      //showToast("No internet connection!");
      //return AlertDialog(title: Text("Error"), content: Text("No internet connection!"),);
      if(context.mounted) {
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(title: const Text("Fehler"),
            content: const Text("Keine Internetverbindung!"),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme
                      .of(context)
                      .textTheme
                      .labelLarge,
                ),
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],);
        });
      }
    }
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  checkRedirection() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.getBool('isAgreementRead') == true) {
      isLoggedIn = true;
      Navigator.of(context).pushNamedAndRemoveUntil(
          "/main-menu", ModalRoute.withName('/main-menu'));
    } else {
      Navigator.of(context).pushReplacementNamed("/agreements");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                          labelText: 'Benutzername',
                        ),
                        validator: (text) => sh.textValidator(text),
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Passwort',
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
                          Text("Angemeldet bleiben"),
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
                            ? const Text("Anmelden")
                            : Transform.scale(
                                scale: 0.5,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                )),
                      ),
                      if (_availableBiometrics != null &&
                          _availableBiometrics!.isNotEmpty)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(30),
                            primary: mainButtonColor,
                          ),
                          onPressed: _authenticateWithBiometrics,
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "Anmelden mit Touch ID / Face ID",
                                style: TextStyle(color: mainButtonColor),
                              ),
                              Icon(
                                Icons.fingerprint,
                                color: mainButtonColor,
                              ),
                            ],
                          ),
                        ),
                      if (proceedLoginWithTouchId)
                        const Column(
                          children: [
                            Text(
                                "Bitte melden Sie sich zum ersten Mal an, um die Touch-ID/Face-ID-Anmeldung zu aktivieren")
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
