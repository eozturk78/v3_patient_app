import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../shared/bottom-menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Apis apis = Apis();
  String title = "";
  String? bloodPressureValue,
      pulseValue,
      saturationValue,
      temperatureValue,
      weightValue;
  @override
  initState() {
    super.initState();
    getPatientInfo();
    getMainData();
  }

  getPatientInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      title = pref.getString("patientTitle") ?? "";
    });
  }

  getMainData() {
    apis.getpatientmaindata().then((resp) {
      if (resp != null) {
        setState(() {
          bloodPressureValue = resp['bloodPressureValue'];
          pulseValue = resp['pulseValue'].toString();
          saturationValue = resp['saturationValue'].toString();
          temperatureValue = resp['temperatureValue'].toString();
          weightValue = resp['weightValue'].toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalObjectKey<ExpandableFabState>(context);
    return Scaffold(
      appBar: leading('Hallo ${title}!', context),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: CustomListComponent(
                      Icons.area_chart,
                      "Blutdruck",
                      "Heute: $bloodPressureValue mmHg",
                      bloodPressureValue == null
                          ? "Bitte tägliche Messung durchführen"
                          : "Tägliche Messung  erfolgreich übermittelt",
                      bloodPressureValue == null ? 10 : 20),
                  onTap: () {
                    Navigator.of(context).pushNamed('/measurement-result');
                  },
                ),
                GestureDetector(
                  child: CustomListComponent(
                      Icons.monitor_weight_outlined,
                      "Gewicht",
                      "Heute: $weightValue kg",
                      weightValue == null
                          ? "Bitte tägliche Messung durchführen"
                          : "Tägliche Messung  erfolgreich übermittelt",
                      weightValue == null ? 10 : 20),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/measurement-result-weight');
                  },
                ),
                GestureDetector(
                  child: CustomListComponent(
                      Icons.monitor_heart_outlined,
                      "Herzfrequenz",
                      "Heute: $pulseValue bpm",
                      pulseValue == null
                          ? "Bitte tägliche Messung durchführen"
                          : "Tägliche Messung  erfolgreich übermittelt",
                      pulseValue == null ? 10 : 20),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/measurement-result-pulse');
                  },
                ),
                GestureDetector(
                  child: CustomListComponent(
                      Icons.thermostat,
                      "Temperatur",
                      "Heute: $temperatureValue C°",
                      temperatureValue == null
                          ? "Bitte tägliche Messung durchführen"
                          : "Tägliche Messung  erfolgreich übermittelt",
                      temperatureValue == null ? 10 : 20),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/measurement-result-temperature');
                  },
                ),
                GestureDetector(
                  child: CustomListComponent(
                      Icons.air,
                      "Sauerstoffsättigung",
                      "Heute: $saturationValue %",
                      saturationValue == null
                          ? "Bitte tägliche Messung durchführen"
                          : "Tägliche Messung  erfolgreich übermittelt",
                      saturationValue == null ? 10 : 20),
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
                    Navigator.of(context).pushNamed('/questionnaire-group');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: key,
        // duration: const Duration(seconds: 1),
        distance: 60.0,
        type: ExpandableFabType.up,
        // fanAngle: 70,
        child: const Icon(Icons.add),
        overlayStyle: ExpandableFabOverlayStyle(
          blur: 3,
        ),
        onOpen: () {
          debugPrint('onOpen');
        },
        afterOpen: () {
          debugPrint('afterOpen');
        },
        onClose: () {
          debugPrint('onClose');
        },
        afterClose: () {
          debugPrint('afterClose');
        },
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
              Navigator.of(context).pushNamed('/questionnaire-group');
            },
            icon: new Icon(Icons.medication_outlined),
            label: Text("Grafische Darstellungen"),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigatorBar(0),
    );
  }
}
