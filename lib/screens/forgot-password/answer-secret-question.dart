import 'dart:convert';
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
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
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    onGetQuestion();
    super.initState();
  }

  onGetQuestion() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      question = pref.getString('question')!;
    });
  }

  onCheckAnswer() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var answer = pref.getString('answer')!;
    var userName = pref.getString('userName')!;
    if (answer == answerController.text) {
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
    } else {
      showToast("Bitte überprüfen Sie Ihre Antwort");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: leadingWithoutProfile("Passwort vergessen", context),
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
                      decoration: const InputDecoration(
                        labelText: 'Antwort',
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
                        final isValid = _formKey.currentState?.validate();
                        if (!isValid! || isSendEP) return;
                        onCheckAnswer();
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
    );
  }
}
