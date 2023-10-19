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

class TemporaryPasswordPage extends StatefulWidget {
  const TemporaryPasswordPage({super.key});
  @override
  State<TemporaryPasswordPage> createState() => _TemporaryPasswordPageState();
}

class _TemporaryPasswordPageState extends State<TemporaryPasswordPage> {
  TextEditingController answerController = TextEditingController();
  Apis apis = Apis();
  Shared sh = Shared();
  bool isSendEP = false;
  String? temporaryPassword;
  final _formKey = GlobalKey<FormState>();
  String? deviceToken;
  @override
  void initState() {
    FirebaseMessaging _firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    _firebaseMessaging.getToken().then((token) {
      if (token != null) deviceToken = token;
    });
    onGetQuestion();
    super.initState();
  }

  onGetQuestion() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      temporaryPassword = pref.getString('temporaryPassword')!;
    });
  }

  onResetPassword() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userName = pref.getString('userName')!;

    apis.resetPassword(userName).then(
      (resp) async {
        print(resp['temporaryPassword']);
        pref.setString("temporaryPassword", resp['temporaryPassword']);

        await apis.login(userName, resp['temporaryPassword'], deviceToken).then(
            (value) async {
          if (value != null) {
            setState(() {
              isSendEP = false;
            });
            pref.setString("patientTitle", value['firstName']);
            pref.setString('token', value['token']);
            pref.setString('patientGroups', jsonEncode(value['token']));
            Navigator.of(context).pushNamed('/change-password');
          }
        }, onError: (err) {
          setState(() {
            isSendEP = false;
          });
          print(err);
          try {
            sh.redirectPatient(err, context);
          } catch (e) {
            showToast(e.toString());
          }
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
                    Text("Do you want to  continue reset your password?"),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            onResetPassword();
                          },
                          child: Text('Yes'),
                          style: ElevatedButton.styleFrom(
                            primary: mainButtonColor,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('No'),
                          style: ElevatedButton.styleFrom(
                            primary: mainItemColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
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
