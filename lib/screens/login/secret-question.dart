import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v3_patient_app/colors/colors.dart';
import 'package:v3_patient_app/screens/shared/shared.dart';
import 'package:v3_patient_app/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

import '../../apis/apis.dart';
import '../../model/secret-question.dart';
import '../../shared/shared.dart';

class SecretQuestionPage extends StatefulWidget {
  const SecretQuestionPage({super.key});
  @override
  State<SecretQuestionPage> createState() => _SecretQuestionPageState();
}

class _SecretQuestionPageState extends State<SecretQuestionPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController answerController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  Apis apis = Apis();
  Shared sh = Shared();
  bool isSendEP = false;
  int? questionId;
  List<SecretQuestion> questionList = [];
  bool isSelectedQuestion = true;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    onGetQuestionList();
    super.initState();
  }

  onGetQuestionList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isSendEP = true;
    });
    apis.getPatientSecretQuestions().then(
      (resp) {
        if (resp != null) {
          setState(() {
            isSendEP = false;
            questionList =
                (resp as List).map((e) => SecretQuestion.fromJson(e)).toList();

            questionList.add(SecretQuestion(
                secretQuestionId: null,
                question: sh.getLanguageResource("define_own_question")));

            print(questionList);
          });
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

  onSecretQuestion() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isSendEP = true;
    });
    var ownQuestion = null;
    if (!questionController.text.isEmpty) ownQuestion = questionController.text;

    apis
        .setSecretQuestion(null, questionId, ownQuestion, answerController.text)
        .then(
      (resp) {
        if (resp != null) {
          setState(() {
            isSendEP = false;
          });
          Navigator.of(context).pushReplacementNamed("/main-menu");
        }
      },
      onError: (err) {
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
      appBar: leadingWithoutProfile(
          sh.getLanguageResource("security_issues"), context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sh.getLanguageResource("pleae_create_security_question"),
                      style: labelText,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      sh.getLanguageResource("security_issues"),
                      style: labelText,
                    ),
                    SizedBox(
                      height: 40,
                      child: DropdownButton<int>(
                        isExpanded: true,
                        underline: SizedBox(),
                        alignment: Alignment.bottomRight,
                        borderRadius: BorderRadius.circular(15),
                        value: questionId,
                        onChanged: (value) {
                          setState(() {
                            questionId = value;
                            isSelectedQuestion = true;
                          });
                        },
                        items: questionList
                            .map((item) => DropdownMenuItem(
                                  child: Text(
                                    item.question,
                                  ),
                                  value: item.secretQuestionId,
                                ))
                            .toList(),
                      ),
                    ),
                    Divider(
                      color: const Color.fromARGB(255, 54, 54, 54),
                    ),
                    if (isSelectedQuestion == true && questionId == null)
                      TextFormField(
                        controller: questionController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: sh.getLanguageResource(
                              "please_write_your_own_question"),
                        ),
                        validator: (text) => sh.textValidator(text),
                      ),
                    TextFormField(
                      controller: answerController,
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
                        minimumSize: const Size.fromHeight(40),
                        backgroundColor: mainButtonColor,
                      ),
                      onPressed: () async {
                        final isValid = _formKey.currentState?.validate();
                        print("=========");
                        // if (!isValid! || isSendEP) return;
                        onSecretQuestion();
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
    );
  }
}
