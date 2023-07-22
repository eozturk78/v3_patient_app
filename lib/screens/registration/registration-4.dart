import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../../shared/shared.dart';
import '../shared/shared.dart';

class Registration4Page extends StatefulWidget {
  const Registration4Page({super.key});
  @override
  State<Registration4Page> createState() => _Registration4PageState();
}

class _Registration4PageState extends State<Registration4Page> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController repeatPasswordController = new TextEditingController();
  Shared sh = new Shared();
  late Widget passwordCheck;
  bool isSendEP = false;
  @override
  void initState() {
    // TODO: implement initState
    passwordCheck = checkPassword(passwordController.text);
    checkRemeberMe();
    super.initState();
  }

  checkRemeberMe() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingWithoutProfile('Registration 4!', context),
      body: Padding(
        padding: EdgeInsets.all(30),
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
                      "Erstellen Sie jetzt Ihr Benutzerkonto",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: mainButtonColor),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        'Bitte geben Sie Ihre E-Mail-Adresse an. Wir senden Ihnen im Anschluss eine Bestätigungsmail.'),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "E-Mail-Adresse",
                      style: labelText,
                    ),
                    TextFormField(
                      controller: emailController,
                      obscureText: false,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Bitte eintragen',
                      ),
                      validator: (text) => sh.emailValidator(text),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(color: const Color.fromARGB(255, 134, 134, 134)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Passwort",
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
                    SizedBox(
                      height: 10,
                    ),
                    Divider(color: const Color.fromARGB(255, 134, 134, 134)),
                    SizedBox(
                      height: 10,
                    ),
                    passwordCheck,
                    SizedBox(
                      height: 10,
                    ),
                    Divider(color: const Color.fromARGB(255, 134, 134, 134)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Passwort bestätigen",
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
                    SizedBox(
                      height: 10,
                    ),
                    Divider(color: const Color.fromARGB(255, 134, 134, 134)),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                        primary: mainButtonColor,
                      ),
                      onPressed: () async {
                        final isValid = _formKey.currentState?.validate();
                        if ((!isValid! || isSendEP) ||
                            (!sh.hasSpecialChars(passwordController.text)) ||
                            (!sh.hasLowerCase(passwordController.text)) ||
                            (!sh.hasUpperCase(passwordController.text)) ||
                            (passwordController.text.length < 10)) return;

                        setState(() {
                          isSendEP = true;
                        });
                        Apis apis = Apis();
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        apis
                            .registerPatient(
                                emailController.text,
                                pref.getString("firstName").toString(),
                                pref.getString("lastName").toString(),
                                pref.getString("birthDate").toString(),
                                pref.getString("weight").toString(),
                                pref.getString("height").toString(),
                                pref.getString("gender").toString(),
                                emailController.text,
                                passwordController.text,
                                pref.getString("sex").toString())
                            .then((value) {
                          setState(() {
                            isSendEP = false;
                          });
                          pref.clear();
                          Navigator.of(context)
                              .pushNamed('/created-account-successfully');
                        },
                                onError: (err) => {
                                      setState(() {
                                        isSendEP = false;
                                      })
                                    });
                      },
                      child: !isSendEP
                          ? const Text("REGISTRIEN")
                          : Transform.scale(
                              scale: 0.5,
                              child: CircularProgressIndicator(
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
