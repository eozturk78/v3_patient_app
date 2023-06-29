import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:url_launcher/url_launcher.dart';

import '../shared/bottom-menu.dart';
import '../shared/medication-plan-box.dart';

class MedicationPlanListPage extends StatefulWidget {
  const MedicationPlanListPage({super.key});

  @override
  State<MedicationPlanListPage> createState() => _MedicationPlanListPageState();
}

class _MedicationPlanListPageState extends State<MedicationPlanListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Medikamentenplan!', context),
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                await launch(
                    "https://api.imc-app.de/medicalplan-pdf?treatmentid=1687519862205");
              },
              child: CustomMedicationPlanBox("Medikamentenplan_01_26-06-2023",
                  "23.06.2023 11:33", "David Brockmann"),
            ),
            GestureDetector(
                onTap: () async {
                  await launch(
                      "https://api.imc-app.de/medicalplan-pdf?treatmentid=1687519862205");
                },
                child: CustomMedicationPlanBox("Medikamentenplan_02_26-06-2023",
                    "23.06.2023 11:21", "David Brockmann")),
          ],
        ),
      )), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(2),
    );
  }
}
