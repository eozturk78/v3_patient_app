import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v3_patient_app/colors/colors.dart';
import 'package:v3_patient_app/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../../shared/shared.dart';
import '../shared/shared.dart';

class Registration6Page extends StatefulWidget {
  const Registration6Page({super.key});
  @override
  State<Registration6Page> createState() => _Registration6PageState();
}

class _Registration6PageState extends State<Registration6Page> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController repeatPasswordController = new TextEditingController();
  Shared sh = Shared();
  late Widget passwordCheck;
  bool isSendEP = false;
  @override
  void initState() {
    // TODO: implement initState
    passwordCheck = checkPassword(passwordController.text);
    checkRememberMe();
    super.initState();
  }

  checkRememberMe() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingWithoutProfile(
          sh.getLanguageResource("registration_5"), context),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: SizedBox(
              width: double.infinity,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sh.getLanguageResource("create_your_user_account"),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: mainButtonColor),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      sh.getLanguageResource("please_enter_your_email"),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      sh.getLanguageResource("email"),
                      style: labelText,
                    ),
                    TextFormField(
                      controller: emailController,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: sh.getLanguageResource("please_enter"),
                      ),
                      validator: (text) => sh.emailValidator(text),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(color: Color.fromARGB(255, 134, 134, 134)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      sh.getLanguageResource("password"),
                      style: labelText,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      onChanged: (value) => setState(() {
                        passwordCheck = checkPassword(passwordController.text);
                      }),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      validator: (text) => sh.textValidator(text),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(color: Color.fromARGB(255, 134, 134, 134)),
                    const SizedBox(
                      height: 10,
                    ),
                    passwordCheck,
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(color: Color.fromARGB(255, 134, 134, 134)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      sh.getLanguageResource("confirm_password"),
                      style: labelText,
                    ),
                    TextFormField(
                      controller: repeatPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      validator: (text) =>
                          sh.textRepeatPassword(text, passwordController.text),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(color: Color.fromARGB(255, 134, 134, 134)),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                        backgroundColor: mainButtonColor,
                      ),
                      onPressed: () async {
                        final isValid = _formKey.currentState?.validate();
                        if ((!isValid! || isSendEP) ||
                            (!sh.hasSpecialChars(passwordController.text)) ||
                            (!sh.hasLowerCase(passwordController.text)) ||
                            (!sh.hasUpperCase(passwordController.text)) ||
                            (passwordController.text.length < 10)) return;

                        setState(() {
                          //  isSendEP = true;
                        });
                        Apis apis = Apis();
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        print(pref
                            .getString("birthDate")
                            .toString()
                            .substring(0, 10));
                        apis
                            .registerPatient(
                                pref.getInt("organizationId")!,
                                pref.getString("healthId").toString(),
                                pref.getString("firstName").toString(),
                                pref.getString("lastName").toString(),
                                pref.getInt("countryId")!,
                                pref.getInt("cityId")!,
                                pref.getString("street").toString(),
                                pref.getString("mobilePhoneNumber").toString(),
                                pref.getString("postalCode").toString(),
                                pref.getString("birthDate").toString(),
                                double.parse(pref.getString("weight").toString()),
                                double.parse(pref.getString("height").toString()),
                                pref.getString("sex").toString(),
                                emailController.text,
                                passwordController.text)
                            .then((value) {
                          setState(() {
                            isSendEP = false;
                          });
                          pref.clear();
                          Navigator.of(context)
                              .pushNamed('/created-account-successfully');
                        });
                      },
                      child: !isSendEP
                          ? Text(sh.getLanguageResource("registry"))
                          : Transform.scale(
                              scale: 0.5,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              )),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
