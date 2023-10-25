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

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController userNameController = TextEditingController();
  Apis apis = Apis();
  Shared sh = Shared();
  bool isSendEP = false;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  onForgotPassword() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isSendEP = true;
    });
    pref.remove("answer");
    pref.remove("question");
    pref.remove("supportPhoneNumber");
    pref.remove("supportEmail");
    var userName = userNameController.text; //pref.getString("userName");
    apis.getSecretQuestion(userName!).then(
      (resp) {
        print(resp);
        if (resp != null) {
          setState(() {
            isSendEP = false;
          });
          if (resp['answer'] != null) pref.setString("answer", resp['answer']);
          if (resp['question'] != null)
            pref.setString('question', resp['question']);
          if (resp['supportphonenumber'] != null)
            pref.setString('supportPhoneNumber', resp['supportphonenumber']);
          if (resp['supportemail'] != null)
            pref.setString('supportEmail', resp['supportemail']);
          pref.setString('userName', userName);

          Navigator.of(context).pushReplacementNamed("/answer-secret-question");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: leadingWithoutProfile("Passwort vergessen", context),
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
                        Text(
                            "Bitte geben Sie Ihren Benutzernamen ein, um das Passwort zurückzusetzen"),
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(30),
                            primary: mainButtonColor,
                          ),
                          onPressed: () async {
                            final isValid = _formKey.currentState?.validate();
                            if (!isValid! || isSendEP) return;
                            onForgotPassword();
                          },
                          child: !isSendEP
                              ? const Text("Send")
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
