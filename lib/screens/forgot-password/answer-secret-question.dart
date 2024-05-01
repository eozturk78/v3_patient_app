import 'dart:convert';
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:patient_app/shared/toast.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../apis/apis.dart';
import '../../shared/shared.dart';

class AnswerSecretQuestionPage extends StatefulWidget {
  const AnswerSecretQuestionPage({super.key});
  @override
  State<AnswerSecretQuestionPage> createState() =>
      _AnswerSecretQuestionPageState();
}

class _AnswerSecretQuestionPageState extends State<AnswerSecretQuestionPage> {
  TextEditingController answerController = TextEditingController();
  Apis apis = Apis();
  Shared sh = Shared();
  bool isSendEP = false;
  String? question;
  String? supportPhoneNumber;
  String? supportEmail;
  final _formKey = GlobalKey<FormState>();
  int fpType = 100; // 10 with secret question 20 with contact
  @override
  void initState() {
    onGetQuestion();
    super.initState();
  }

  onGetQuestion() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      question = pref.getString('question') ?? null;
      supportPhoneNumber = pref.getString('supportPhoneNumber') ?? null;
      supportEmail = pref.getString('supportEmail') ?? null;
      setState(() {
        if (question != null)
          fpType = 10;
        else if (supportEmail != null) fpType = 20;
      });
    });
  }

  bool isEmailSent = false;
  resetPasswordRequestEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isSendEP = true;
    });
    var userName = pref.getString('userName')!;

    apis.resetPasswordRequestEmail(userName).then(
      (resp) {
        setState(() {
          isEmailSent = true;
          isSendEP = false;
        });
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

  onCheckAnswer() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    //var answer = pref.getString('answer')!;
    var userName = pref.getString('userName')!;
    // if (answer == answerController.text) {
    apis.onCheckAnswer(answerController.text, userName).then(
      (resp) {
        Navigator.of(context).pushReplacementNamed("/temporary-password");
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
    /*} else {
      showToast("Bitte überprüfen Sie Ihre Antwort");
    }*/
  }

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
          sh.getLanguageResource("forgetten_password"),
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (question != null &&
                                (supportEmail != null ||
                                    supportPhoneNumber != null))
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    ResponsiveValue(
                                      context,
                                      defaultValue: 0.38,
                                      conditionalValues: [
                                        Condition.largerThan(
                                          //Tablet
                                          name: MOBILE,
                                          value: 0.2,
                                        ),
                                      ],
                                    ).value!,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: fpType == 10
                                          ? mainButtonColor
                                          : mainItemColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        fpType = 10;
                                      });
                                    },
                                    child: Text(sh.getLanguageResource(
                                        "security_question"))),
                              ),
                            SizedBox(
                              width: 5,
                            ),
                            if ((supportEmail != null ||
                                    supportPhoneNumber != null) &&
                                (question != null))
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    ResponsiveValue(
                                      context,
                                      defaultValue: 0.38,
                                      conditionalValues: [
                                        Condition.largerThan(
                                          //Tablet
                                          name: MOBILE,
                                          value: 0.2,
                                        ),
                                      ],
                                    ).value!,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: fpType == 20
                                          ? mainButtonColor
                                          : mainItemColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        fpType = 20;
                                      });
                                    },
                                    child: Text(sh.getLanguageResource(
                                        "contact_to_clinic"))),
                              ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        if (fpType == 10)
                          Column(
                            children: [
                              Text(
                                question!,
                                style: labelText,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: answerController,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: sh.getLanguageResource("answer"),
                                ),
                                validator: (text) => sh.textValidator(text),
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
                                  final isValid =
                                      _formKey.currentState?.validate();
                                  if (!isValid! || isSendEP) return;
                                  onCheckAnswer();
                                },
                                child: !isSendEP
                                    ? Text(
                                        sh.getLanguageResource("send"),
                                      )
                                    : Transform.scale(
                                        scale: 0.5,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                              )
                            ],
                          )
                        else
                          Column(
                            children: [
                              if (supportEmail != null ||
                                  supportPhoneNumber != null)
                                Text(
                                  sh.getLanguageResource(
                                      "select_contact_method"),
                                  style: labelText,
                                ),
                              const SizedBox(
                                height: 5,
                              ),
                              if (supportPhoneNumber != null)
                                Column(
                                  children: [
                                    Text("$supportPhoneNumber"),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      child: ElevatedButton(
                                          onPressed: () => launch(
                                              "tel://$supportPhoneNumber"),
                                          child: Text(
                                            sh.getLanguageResource(
                                                "call_clinician"),
                                          )),
                                    ),
                                  ],
                                ),
                              if (supportEmail != null)
                                Column(
                                  children: [
                                    Text("$supportEmail"),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            resetPasswordRequestEmail();
                                          },
                                          child: !isSendEP
                                              ? Text(
                                                  sh.getLanguageResource(
                                                      "send_email_to_clinician"),
                                                )
                                              : Transform.scale(
                                                  scale: 0.5,
                                                  child:
                                                      const CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.white,
                                                  ))),
                                    )
                                  ],
                                ),
                              if (supportEmail == null &&
                                  supportPhoneNumber == null)
                                Text(
                                  sh.getLanguageResource(
                                      "contact_imedcom_support"),
                                )
                            ],
                          ),
                        if (isEmailSent)
                          Text(
                            sh.getLanguageResource(
                                "send_email_to_clinician_desc"),
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
