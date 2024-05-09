import 'dart:convert';
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:patient_app/shared/toast.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

import '../../apis/apis.dart';
import '../../shared/shared.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController repeatNewPasswordController = TextEditingController();
  Apis apis = Apis();
  Shared sh = Shared();
  bool isSendEP = false;
  String? deviceToken;
  final _formKey = GlobalKey<FormState>();
  bool fromForgotPassword = false;
  @override
  void initState() {
    // TODO: implement initState
    FirebaseMessaging _firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    _firebaseMessaging.getToken().then((token) {
      if (token != null) deviceToken = token;
    });
    checkUserWhere();
    super.initState();
  }

  checkUserWhere() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('temporaryPassword') != null)
      setState(() {
        fromForgotPassword = true;
      });
  }

  onChangePassword() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isSendEP = true;
    });
    var userName = pref.getString("userName");
    var pass = passwordController.text;
    if (pref.getString('temporaryPassword') != null)
      pass = pref.getString('temporaryPassword')!;

    pref.remove("temporaryPassword");
    pref.remove("question");
    pref.remove("answer");
    apis
        .changePassword(
            userName!, newPasswordController.text, pass, deviceToken)
        .then(
      (resp) {
        if (resp != null) {
          setState(() {
            isSendEP = false;
          });
          pref.setString("patientTitle", resp['firstName']);
          pref.setString('token', resp['token']);

          if (resp['isRequiredSecretQuestion']) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                "/successfully-changed-password",
                ModalRoute.withName('/login'));
          } else
            Navigator.of(context).pushNamed("/secret-question");
        }
      },
      onError: (err) {
        sh.redirectPatient(err, context);
        setState(
          () {
            isSendEP = false;
          },
        );
      },
    );
  }

  bool obSecuredText1 = false;
  bool obSecuredText2 = false;
  bool obSecuredText3 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          sh.getLanguageResource("change_password"),
          style: TextStyle(color: Colors.black),
        ),
        shadowColor: null,
        elevation: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
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
                    value: 0.5,
                  ),
                ],
              ).value!,
          child: Column(
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
                        if (!fromForgotPassword)
                          TextFormField(
                            controller: passwordController,
                            obscureText: !obSecuredText1,
                            decoration: InputDecoration(
                              labelText:
                                  sh.getLanguageResource("current_password"),
                              suffixIcon: IconButton(
                                icon: obSecuredText1 == true
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    obSecuredText1 = !obSecuredText1;
                                  });
                                },
                              ),
                            ),
                            validator: (text) => sh.textValidator(text),
                          ),
                        TextFormField(
                          controller: newPasswordController,
                          obscureText: !obSecuredText2,
                          decoration: InputDecoration(
                            labelText: sh.getLanguageResource("new_password"),
                            suffixIcon: IconButton(
                              icon: obSecuredText2 == true
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  obSecuredText2 = !obSecuredText2;
                                });
                              },
                            ),
                          ),
                          validator: (text) => sh.textValidator(text),
                        ),
                        TextFormField(
                          controller: repeatNewPasswordController,
                          obscureText: !obSecuredText3,
                          validator: (text) => sh.textRepeatPassword(
                              text, newPasswordController.text),
                          decoration: InputDecoration(
                            labelText:
                                sh.getLanguageResource("repeat_new_password"),
                            suffixIcon: IconButton(
                              icon: obSecuredText3 == true
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  obSecuredText3 = !obSecuredText3;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(30), backgroundColor: mainButtonColor,
                          ),
                          onPressed: () async {
                            final isValid = _formKey.currentState?.validate();
                            if (!isValid! || isSendEP) return;
                            onChangePassword();
                          },
                          child: !isSendEP
                              ? Text(sh.getLanguageResource("send"))
                              : Transform.scale(
                                  scale: 0.5,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
