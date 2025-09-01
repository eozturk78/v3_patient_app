import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v3_patient_app/colors/colors.dart';
import 'package:v3_patient_app/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../../shared/shared.dart';
import '../shared/shared.dart';

class Registration3Page extends StatefulWidget {
  const Registration3Page({super.key});
  @override
  State<Registration3Page> createState() => _Registration3PageState();
}

class _Registration3PageState extends State<Registration3Page> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController healthIdController = new TextEditingController();
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  Shared sh = new Shared();
  bool isSendEP = false;
  @override
  void initState() {
    // TODO: implement initState
    checkRemeberMe();
    super.initState();
  }

  checkRemeberMe() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingWithoutProfile(
          sh.getLanguageResource("registration_3"), context),
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
                        sh.getLanguageResource("personalisation"),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: mainButtonColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(sh.getLanguageResource("let_us_customise"),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 60,
                      ),
                      Text(
                        sh.getLanguageResource("health_id"),
                        style: labelText,
                      ),
                      TextFormField(
                        controller: healthIdController,
                        obscureText: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:
                              sh.getLanguageResource("please_enter_health_id"),
                        ),
                        validator: (text) => sh.textValidator(text),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(color: const Color.fromARGB(255, 134, 134, 134)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        sh.getLanguageResource("first_name"),
                        style: labelText,
                      ),
                      TextFormField(
                        controller: firstNameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:
                              sh.getLanguageResource("please_enter_your_name"),
                        ),
                        validator: (text) => sh.textValidator(text),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(color: const Color.fromARGB(255, 134, 134, 134)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        sh.getLanguageResource("last_name"),
                        style: labelText,
                      ),
                      TextFormField(
                        controller: lastNameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:
                              sh.getLanguageResource("pleae_enter_surname"),
                        ),
                        validator: (text) => sh.textValidator(text),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(color: const Color.fromARGB(255, 134, 134, 134)),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          backgroundColor: mainButtonColor,
                        ),
                        onPressed: () async {
                          final isValid = _formKey.currentState?.validate();
                          if (!isValid! || isSendEP) return;
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.setString('healthId', healthIdController.text);
                          pref.setString('firstName', firstNameController.text);
                          pref.setString('lastName', lastNameController.text);
                          Navigator.of(context).pushNamed('/registration-4');
                        },
                        child: Text(
                          sh.getLanguageResource("further"),
                        ),
                      )
                    ],
                  ),
                ))),
      ),
    );
  }
}
