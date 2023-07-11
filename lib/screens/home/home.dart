import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/bottom-menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String title = "";
  @override
  initState() {
    getPatientInfo();
    super.initState();
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
      appBar: leading('Hallo ${title}!', context),
      body: Center(
          child: Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: const CustomListComponent(
                          Icons.thermostat_outlined,
                          "Blutdruck",
                          "Heute: 122/84 mmHg",
                          "Bitte tägliche Messung durchführen",
                          10),
                      onTap: () {
                        Navigator.of(context).pushNamed('/measurement-result');
                      },
                    ),
                    GestureDetector(
                      child: const CustomListComponent(
                          Icons.monitor_weight_outlined,
                          "Gewicht",
                          "Heute: 103 kg",
                          "Tägliche Messung  erfolgreich übermittelt",
                          20),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/measurement-result-weight');
                      },
                    ),
                    GestureDetector(
                      child: const CustomListComponent(
                          Icons.monitor_heart_outlined,
                          "Herzfrequenz",
                          "Heute: 66.2 bpm",
                          "Bitte tägliche Messung durchführen",
                          10),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/measurement-result-pulse');
                      },
                    ),
                    GestureDetector(
                      child: const CustomListComponent(
                          Icons.thermostat,
                          "Temperatur",
                          "Heute: 36 C°",
                          "Tägliche Messung  erfolgreich übermittelt",
                          20),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/measurement-result-temperature');
                      },
                    ),
                    GestureDetector(
                      child: const CustomListComponent(
                          Icons.air,
                          "Sauerstoffsättigung",
                          "Heute: - %",
                          "Bitte tägliche Messung durchführen",
                          10),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/measurement-result-saturation');
                      },
                    ),
                    GestureDetector(
                      child: const CustomListComponent(
                          Icons.question_mark_outlined,
                          "Fragebögen",
                          "Heute: - %",
                          "Bitte Fragebögen beantworten",
                          10),
                      onTap: () {
                        Navigator.of(context).pushNamed('/questionnaire-1');
                      },
                    ),
                  ],
                ),
              ))), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(0),
    );
  }
}
