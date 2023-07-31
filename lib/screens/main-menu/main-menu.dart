import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../../shared/shared.dart';
import '../shared/bottom-menu.dart';
import '../shared/sub-total.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  Apis apis = Apis();
  Shared sh = Shared();

  String title = "";
  @override
  void initState() {
    super.initState();
    getPatientInfo();
  }

  getPatientInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      title = pref.getString('patientTitle')!;
      pref.setString("patientTitle", title);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingWithoutBack('Hallo ${title}!', context),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: [
            Row(
              children: [
                GestureDetector(
                  child: const CustomSubTotal(Icons.person_outlined,
                      "Mein Benutzerprofil", null, null, 10),
                  onTap: () {
                    Navigator.of(context).pushNamed('/profile');
                  },
                ),
                Spacer(),
                GestureDetector(
                  child: const CustomSubTotal(Icons.person_add_alt_1_outlined,
                      "Datenmanagement", null, null, 20),
                  onTap: () {
                    Navigator.of(context).pushNamed('/main-sub-menu');
                  },
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  child: const CustomSubTotal(
                      Icons.medical_information_outlined,
                      "Medikation & Rezepte",
                      null,
                      null,
                      10),
                  onTap: () {
                    Navigator.of(context).pushNamed('/medication');
                  },
                ),
                Spacer(),
                GestureDetector(
                  child: const CustomSubTotal(Icons.chat_bubble_outline_rounded,
                      "Kommunikation", null, null, 20),
                  onTap: () {
                    Navigator.of(context).pushNamed('/comunication');
                  },
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: const CustomSubTotal(Icons.info_outline,
                      "Dokumente & Informationen", null, null, 10),
                  onTap: () {
                    Navigator.of(context).pushNamed('/info');
                  },
                ),
                Spacer(),
                GestureDetector(
                  child: const CustomSubTotal(Icons.view_cozy_outlined,
                      "Schnellzugriff festlegen", null, null, 10),
                  onTap: () {
                    Navigator.of(context).pushNamed('/quick-access');
                  },
                ),
              ],
            ),
          ],
        ),
      )), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(0),
    );
  }
}
