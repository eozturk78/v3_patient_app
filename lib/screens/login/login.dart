import 'dart:convert';
import 'dart:async';
import 'dart:io';

//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:v3_patient_app/colors/colors.dart';
import 'package:v3_patient_app/screens/main-menu/main-menu.dart';
import 'package:v3_patient_app/screens/shared/shared.dart';
import 'package:v3_patient_app/shared/toast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import '../../apis/apis.dart';
import '../../main.dart';
import '../../shared/shared.dart';

class LoginPage extends StatefulWidget {
  final bool isDiaglog;
  const LoginPage({required this.isDiaglog});
  @override
  State<LoginPage> createState() => _LoginPageState(this.isDiaglog);
}

class _LoginPageState extends State<LoginPage> {
  bool isDiaglog;
  _LoginPageState(this.isDiaglog);

  TextEditingController userNameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Shared sh = new Shared();
  Apis apis = new Apis();
  bool rememberMeState = false;
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
  bool _isRequiredSecretQuestion = false;
  String? deviceToken;
  bool hasInternelConnection = false;

  @override
  void initState() {
    // TODO: implement initState
    /* FirebaseMessaging _firebaseMessaging =
        FirebaseMessaging.instance; // Change here

    _firebaseMessaging.getToken().then((token) {
      if (token != null) deviceToken = token;
    });*/
    checkRememberMe();
    _getAvailableBiometrics();
    //_authenticateWithBiometrics();

    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }

  late final StreamSubscription<InternetConnectionStatus> _listener;
  InternetConnectionStatus? _internetStatus;
  checkRememberMe() async {
    _listener = InternetConnectionChecker()
        .onStatusChange
        .listen((InternetConnectionStatus status) {
      setState(() {
        _internetStatus = status;
      });
    });
    // close listener after 30 seconds, so the program doesn't run forever
    // await Future<void>.delayed(const Duration(seconds: 30));
    //  await listener.cancel();

    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("rememberMe") == true.toString()) {
      rememberMeState = true;
      userNameController.text = pref.getString("userName")!;
      passwordController.text = pref.getString("password")!;
    }
  }

  Future<bool> authenticateIsAvailable() async {
    try {
      final isAvailable = await auth.canCheckBiometrics;
      final isDeviceSupported = await auth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } on PlatformException catch (e) {
      return false;
    }
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
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
          localizedReason: 'Scan your fingerprint (or face) to authenticate',
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
    final navBarVisibility =
        Provider.of<NavBarVisibility>(context, listen: false);

    setState(() {
      isSendEP = true;
    });
    bool isConnected = false;
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      isConnected = true;
    }
    if (isConnected) {
      //print('Has internet connection!');
      await _listener.cancel();
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("userName", userNameController.text);
      if (rememberMeState) {
        pref.setString("rememberMe", true.toString());
        pref.setString("password", passwordController.text);
      } else if (proceedLoginWithTouchId) {
        pref.setString("userName", userNameController.text);
        pref.setString("password", passwordController.text);
      } else {
        pref.remove("rememberMe");
      }
      await apis
          .login(userNameController.text, passwordController.text, deviceToken)
          .then((value) async {
        print(value);
        if (value != null) {
          // TODO: add else block to this if block
          setState(() {
            isSendEP = false;
            hideNavBar = false;
            navBarVisibility.updateHideNavBar(false);
          });
          pref.setString("patientTitle", value['firstName']);
          pref.setString('token', value['token']);

          //tokenTimeOutSecondDB = value['tokenTimeOutSecond'];
          // tokenTimeOutSecond = value['tokenTimeOutSecond'];
          // popUpAppearSecond = value['popUpAppearSecond'];

          checkRedirection();
        }
      }, onError: (err) {
        setState(() {
          isSendEP = false;
        });
        try {
          sh.redirectPatient(err, context);
        } catch (e) {
          showToast(e.toString());
        }
      });
    } else {
      setState(() {
        isSendEP = false;
      });
      //showToast("No internet connection!");
      //return AlertDialog(title: Text("Error"), content: Text("No internet connection!"),);
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(sh.getLanguageResource("error")),
                content: Text(sh.getLanguageResource("no_internet_connection")),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
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
    var user = pref.getString("userName");

    if (pref.getBool("agreementAccepted") == true) {
      pref.remove("agreementAccepted");
      pref.setBool("${userNameController.text}_isAgreementRead", true);
    } else if (pref.getBool('${user}_isAgreementRead') == true) {
      isLoggedIn = true;

      if (_isRequiredSecretQuestion) {
        if (!Navigator.canPop(context))
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/main-menu', ModalRoute.withName('/main-menu'));
        else
          Navigator.of(context).pop(pref.getString("token")); /* */
        //
      } else
        Navigator.of(context).pushNamed("/main-menu");

      //Navigator.of(context).pushNamed("/secret-question");
    } else {
      Navigator.of(context).pushReplacementNamed("/agreements");
    }
  }

  bool obSecuredText = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width *
              ResponsiveValue(
                context,
                defaultValue: 1,
                conditionalValues: [
                  Condition.largerThan(
                    //Tablet
                    name: MOBILE,
                    value: 0.65,
                  ),
                ],
              ).value!,
          child: SingleChildScrollView(
            child: Column(
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
                          if (_internetStatus != null &&
                              _internetStatus !=
                                  InternetConnectionStatus.connected)
                            Text(
                              "Bitte überprüfen Sie Ihre Internetverbindung",
                              style: TextStyle(
                                  fontSize: 18, color: mainButtonColor),
                            ),
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
                            decoration: InputDecoration(
                              labelText: sh.getLanguageResource("user_name"),
                            ),
                            validator: (text) => sh.textValidator(text),
                          ),
                          TextFormField(
                            controller: passwordController,
                            obscureText: !obSecuredText,
                            decoration: InputDecoration(
                              labelText: sh.getLanguageResource("password"),
                              suffixIcon: IconButton(
                                icon: obSecuredText == true
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    obSecuredText = !obSecuredText;
                                  });
                                },
                              ),
                            ),
                            validator: (text) => sh.textValidator(text),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    rememberMeState = !rememberMeState;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Checkbox(
                                      fillColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.selected)) {
                                            return mainButtonColor; // Set to your login button color
                                          }
                                          return Color.fromARGB(136, 241, 241,
                                              241); // Change to your desired unselected color
                                        },
                                      ),
                                      value: rememberMeState,
                                      onChanged: ((value) => setState(() {
                                            rememberMeState = !rememberMeState;
                                          })),
                                    ),
                                    Text(sh.getLanguageResource("remember_me")),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40),
                              backgroundColor: mainButtonColor,
                            ),
                            onPressed: () async {
                              final isValid = _formKey.currentState?.validate();
                              if (!isValid! || isSendEP) return;
                              onLogin();
                            },
                            child: !isSendEP
                                ? Text(
                                    sh.getLanguageResource("log_in"),
                                    style: TextStyle(color: Colors.white),
                                  )
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
                                //backgroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(30),
                              ),
                              onPressed: _authenticateWithBiometrics,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    sh.getLanguageResource(
                                        "log_in_with_touch_id"),
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
                            Column(
                              children: [
                                Text(sh.getLanguageResource(
                                    "please_login_for_touch_id"))
                                // Text("Bitte melden Sie sich zum ersten Mal an, um die Touch-ID/Face-ID-Anmeldung zu aktivieren")
                              ],
                            ),
                          TextButton(
                            onPressed: () async {
                              await _listener.cancel();
                              //if (this.isDiaglog) Navigator.of(context).pop();
                              Navigator.of(context)
                                  .pushNamed("/forgot-password");
                            },
                            child: Text(
                              sh.getLanguageResource(
                                  "i_have_forgotten_my_password"),
                              //Text('Ich habe mein Passwort vergessen',
                              style: TextStyle(color: mainButtonColor),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await _listener.cancel();
                              //if (this.isDiaglog) Navigator.of(context).pop();
                              Navigator.of(context)
                                  .pushNamed("/registration-1");
                            },
                            child: Text(
                              sh.getLanguageResource("create_new_account"),
                              //Text('Ich habe mein Passwort vergessen',
                              style: TextStyle(color: mainButtonColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                //SharedPreferences glopref =  SharedPreferences.getInstance()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
