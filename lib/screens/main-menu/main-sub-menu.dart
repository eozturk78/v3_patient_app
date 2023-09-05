import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/bottom-menu.dart';
import '../shared/sub-total.dart';

class MainSubMenuPage extends StatefulWidget {
  const MainSubMenuPage({super.key});

  @override
  State<MainSubMenuPage> createState() => _MainSubMenuPageState();
}

class _MainSubMenuPageState extends State<MainSubMenuPage> {
  String title = "";
  @override
  void initState() {
    super.initState();
    getPatientInfo();
  }

  getPatientInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      title = pref.getString("patientTitle") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Daten', context),
      body: SafeArea(
          // Wrap your body with SafeArea
          child: Center(
              child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: [
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  child: const CustomSubTotal(Icons.addchart_outlined,
                      "Tägliche Messungen", null, null, 10),
                  onTap: () {
                    Navigator.of(context).pushNamed('/questionnaire-group');
                  },
                ),
                const Spacer(),
                GestureDetector(
                  child: const CustomSubTotal(
                      Icons.medical_information_outlined,
                      "Grafische Darstellungen",
                      null,
                      null,
                      20),
                  onTap: () {
                    Navigator.of(context).pushNamed('/home');
                  },
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ))), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 1),
    );
  }
}
