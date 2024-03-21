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

import '../../apis/apis.dart';
import '../../shared/shared.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});
  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController repeatNewPasswordController = TextEditingController();
  Apis apis = Apis();
  Shared sh = Shared();
  bool isSendEP = false;
  String? question;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  onChangePassword() async {
    // apis.changeResetPassword()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: leadingWithoutProfile(
            sh.getLanguageResource("forgetten_password"), context),
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
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: newPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: sh.getLanguageResource("new_password"),
                            ),
                            validator: (text) => sh.textValidator(text),
                          ),
                          TextFormField(
                            controller: repeatNewPasswordController,
                            obscureText: true,
                            validator: (text) => sh.textRepeatPassword(
                                text, newPasswordController.text),
                            decoration: InputDecoration(
                              labelText:
                                  sh.getLanguageResource("repeat_new_password"),
                            ),
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
        ));
  }
}
