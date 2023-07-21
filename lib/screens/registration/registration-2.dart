import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../../shared/shared.dart';
import '../shared/shared.dart';

class Registration2Page extends StatefulWidget {
  const Registration2Page({super.key});
  @override
  State<Registration2Page> createState() => _Registration2PageState();
}

class _Registration2PageState extends State<Registration2Page> {
  final _formKey = GlobalKey<FormState>();
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
      appBar: leadingWithoutProfile('Registration 2!', context),
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
                        "Personalisierung",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: mainButtonColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          'Lassen Sie uns iMedCom individuell an Sie anpassen.'),
                      SizedBox(
                        height: 60,
                      ),
                      Text(
                        "Vorname",
                        style: labelText,
                      ),
                      TextFormField(
                        controller: firstNameController,
                        obscureText: false,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Bitte geben Sie Ihren Vornamen ein.',
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
                      Text(
                        "Nachname",
                        style: labelText,
                      ),
                      TextFormField(
                        controller: lastNameController,
                        obscureText: false,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Bitte geben Sie Ihren Nachnamen ein.',
                        ),
                        validator: (text) => sh.textValidator(text),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          primary: mainButtonColor,
                        ),
                        onPressed: () async {
                          // final isValid = _formKey.currentState?.validate();
                          // if (!isValid! || isSendEP) return;
                          Navigator.of(context).pushNamed('/registration-3');
                        },
                        child: Text("Weiter"),
                      )
                    ],
                  ),
                ))),
      ),
    );
  }
}
