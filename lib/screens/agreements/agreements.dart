import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../../shared/shared.dart';
import '../shared/shared.dart';

class AgreementsPage extends StatefulWidget {
  const AgreementsPage({super.key});
  @override
  State<AgreementsPage> createState() => _AgreementsPageState();
}

class _AgreementsPageState extends State<AgreementsPage> {
  Shared sh = new Shared();
  Apis apis = new Apis();
  bool remeberMeState = false;
  bool check1 = false;
  bool check2 = false;
  bool check3 = false;
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
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
              child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/images/logo-imedcom.png",
                  width: 160,
                  height: 70,
                ),
                Text(
                  "Willkomen bei iMedCom",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
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
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed('/terms-and-conditions');
                          },
                          child: Text(
                            "Ich stimme den Nutzungsbedingungen zu.",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )),
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
                          check2 = !check2;
                        });
                      },
                      value: check2,
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
                          check3 = !check3;
                        });
                      },
                      value: check3,
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
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/privacy-policy');
                    },
                    child: Text(
                      "Weitere Hinweise zur Datenverarbeitung finden Sie in unserer Datenschutzinformation.",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    )),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    primary: mainButtonColor,
                  ),
                  onPressed: () async {
                    if (check1 && check2 && check3) {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.setString("isAgreementRed", true.toString());
                      Navigator.of(context).pushNamed('/login');
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
