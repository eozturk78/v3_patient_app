import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../../shared/shared.dart';
import '../shared/shared.dart';

class Registration1Page extends StatefulWidget {
  const Registration1Page({super.key});
  @override
  State<Registration1Page> createState() => _Registration1PageState();
}

class _Registration1PageState extends State<Registration1Page> {
  final _formKey = GlobalKey<FormState>();
  Shared sh = new Shared();
  Apis apis = new Apis();
  bool remeberMeState = false;
  bool check1 = false;
  bool check2 = false;
  bool check3 = false;
  bool check4 = false;
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
      appBar: leading('Registration 1!', context),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
              child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  "Damit Sie iMedCom verwenden dürfen , müssen folgende Voraussetzungen erfüllt sein:",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: mainButtonColor),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Checkbox(
                      onChanged: (value) {
                        setState(() {
                          check1 = !check1;
                        });
                      },
                      value: check1,
                    ),
                    Flexible(
                        child: Text(
                      "Ich bestätige, dass ich mindestens 18 Jahre alt bin und nicht an folgenden Krankheiten leide: ??? und ich nicht schwanger oder in der Stillzeit bin. ",
                      style: TextStyle(fontSize: 16),
                    ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Checkbox(
                      onChanged: (value) {
                        setState(() {
                          check2 = !check2;
                        });
                      },
                      value: check2,
                    ),
                    Flexible(
                      child: Text(
                        "Ich stimme den Nutzungsbedingungen zu.",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                const Text(
                  "Im Rahmen der iMedCom-App-Nutzung werden personenbezogene Daten  verarbeitet:",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: mainButtonColor),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Checkbox(
                      onChanged: (value) {
                        setState(() {
                          check3 = !check3;
                        });
                      },
                      value: check3,
                    ),
                    Flexible(
                        child: Text(
                      "Ich möchte mit meinem Arzt bzw.  meiner Ärztin über „iMedCom-App“ kommunizieren und willige ein, dass meine personenbezogenen Gesundheitsdaten für den bestimmungsgemäßen Gebrauch verarbeitet werden. Ich kann meine Einwilligung jederzeit mit Wirkung für die Zukunft widerrufen. Bitte beachten Sie jedoch, dass Ihr Benutzerkonto gelöscht wird, wenn Sie Ihre Einwilligung widerrufen, da die App ohne Ihre Einwilligung nicht genutzt werden darf. ",
                      style: TextStyle(fontSize: 16),
                    ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Checkbox(
                      onChanged: (value) {
                        setState(() {
                          check4 = !check4;
                        });
                      },
                      value: check4,
                    ),
                    Flexible(
                        child: Text(
                      "Ich willige ein, dass die iMedCom GmbH, Weinbergweg 23, 06120 Halle an der Saale meine Daten verarbeiten darf, um die technische Funktionsfähigkeit und die Nutzerfreundlichkeit der App weiterzuentwickeln. Die Einwilligung ist jederzeit widerrufbar ohne Auswirkungen auf den Funktionsumfang der App. ",
                      style: TextStyle(fontSize: 16),
                    ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    primary: mainButtonColor,
                  ),
                  onPressed: () async {
                    if (check1 && check2 && check3 && check4) {
                      Navigator.of(context).pushNamed('/registration-2');
                    }
                  },
                  child: Text("Weiter"),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}
