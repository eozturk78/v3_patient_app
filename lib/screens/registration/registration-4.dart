import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/shared/toast.dart';
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
      appBar: leadingWithoutProfile('Registration 3!', context),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
              child: SizedBox(
                  width: double.infinity,
                  child: Form(
                    key: _formKey,
                    child: Column(
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
                          height: 40,
                        ),
                        TextFormField(
                          controller: firstNameController,
                          obscureText: false,
                          decoration: const InputDecoration(
                            labelText: 'Geburtsdatum',
                          ),
                          validator: (text) => sh.textValidator(text),
                        ),
                        TextFormField(
                          controller: lastNameController,
                          obscureText: false,
                          decoration: const InputDecoration(
                            labelText: 'Geschlecht',
                          ),
                          validator: (text) => sh.textValidator(text),
                        ),
                        TextFormField(
                          controller: lastNameController,
                          obscureText: false,
                          decoration: const InputDecoration(
                            labelText: 'Größe',
                          ),
                          validator: (text) => sh.textValidator(text),
                        ),
                        TextFormField(
                          controller: lastNameController,
                          obscureText: false,
                          decoration: const InputDecoration(
                            labelText: 'Normalgewicht',
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
                            final isValid = _formKey.currentState?.validate();
                            if (!isValid! || isSendEP) return;
                            Navigator.of(context).pushNamed('/registration-3');
                          },
                          child: Text("Weiter"),
                        )
                      ],
                    ),
                  ))),
        ),
      ),
    );
  }
}
