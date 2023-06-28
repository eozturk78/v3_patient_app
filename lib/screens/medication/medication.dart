import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';

import '../shared/bottom-menu.dart';

class MedicationPage extends StatefulWidget {
  const MedicationPage({super.key});

  @override
  State<MedicationPage> createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leading('Meine Medication!', context),
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
                  child: const CustomListComponent(Icons.text_snippet_outlined,
                      "Medikamentenplan", null, null, 10),
                  onTap: () {
                    Navigator.of(context).pushNamed('/measurement-result');
                  },
                ),
                Spacer(),
                GestureDetector(
                  child: const CustomListComponent(
                      Icons.medical_information_outlined,
                      "Rezept",
                      null,
                      null,
                      20),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/measurement-result-weight');
                  },
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: const CustomListComponent(
                      Icons.medication_liquid_outlined,
                      "Polymed. Check",
                      null,
                      null,
                      10),
                  onTap: () {
                    Navigator.of(context).pushNamed('/measurement-result');
                  },
                ),
              ],
            ),
          ],
        ),
      )), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(2),
    );
  }
}
