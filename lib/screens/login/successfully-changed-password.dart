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
import '../../model/secret-question.dart';
import '../../shared/shared.dart';

class SuccessfullyChangedPasswordPage extends StatefulWidget {
  const SuccessfullyChangedPasswordPage({super.key});
  @override
  State<SuccessfullyChangedPasswordPage> createState() =>
      _SuccessfullyChangedPasswordPageState();
}

class _SuccessfullyChangedPasswordPageState
    extends State<SuccessfullyChangedPasswordPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController answerController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  Apis apis = Apis();
  Shared sh = Shared();
  bool isSendEP = false;
  int? questionId;
  bool isSelectedQuestion = false;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: leadingSubpage("Erfolgreich geändert", context),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified,
                      size: 70,
                      color: const Color.fromARGB(255, 0, 58, 30),
                    ),
                    Text(
                      "Ihr Passwort wurde erfolgreich geändert",
                      style: labelText,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              "/login", ModalRoute.withName('/login'));
                        },
                        child: Text('Zur Anmeldung gehen'))
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
