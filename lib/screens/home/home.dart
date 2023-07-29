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
          bloodPressureValue = resp['bloodPressureValue'] != null
              ? resp['bloodPressureValue']
              : "~";
          pulseValue = resp['pulseValue'] != null ? resp['pulseValue'] : "~";
          saturationValue =
              resp['saturationValue'] != null ? resp['saturationValue'] : "~";
          temperatureValue =
              resp['temperatureValue'] != null ? resp['temperatureValue'] : "~";
          weightValue = resp['weightValue'] != null ? resp['weightValue'] : "~";
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
                      bloodPressureValue != null
                          ? "Heute: $bloodPressureValue mmHg"
                          : "~",
                      bloodPressureValue != null
                          ? bloodPressureValue == "~"
                              ? "Bitte tägliche Messung durchführen"
                              : "Tägliche Messung  erfolgreich übermittelt"
                          : "Warten Sie mal",
                      bloodPressureValue == "~" ? 10 : 20),
                  onTap: () {
                    Navigator.of(context).pushNamed('/measurement-result');
                  },
                ),
                GestureDetector(
                  child: CustomListComponent(
                      Icons.monitor_weight_outlined,
                      "Gewicht",
                      weightValue != null ? "Heute: $weightValue kg" : "~",
                      weightValue != null
                          ? weightValue == "~"
                              ? "Bitte tägliche Messung durchführen"
                              : "Tägliche Messung  erfolgreich übermittelt"
                          : "Warten Sie mal",
                      weightValue == "~" ? 10 : 20),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/measurement-result-weight');
                  },
                ),
                GestureDetector(
                  child: CustomListComponent(
                      Icons.monitor_heart_outlined,
                      "Herzfrequenz",
                      pulseValue != null ? "Heute: $pulseValue bpm" : "~",
                      pulseValue != null
                          ? pulseValue == "~"
                              ? "Bitte tägliche Messung durchführen"
                              : "Tägliche Messung  erfolgreich übermittelt"
                          : "Warten Sie mal",
                      pulseValue == "~" ? 10 : 20),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/measurement-result-pulse');
                  },
                ),
                GestureDetector(
                  child: CustomListComponent(
                      Icons.thermostat,
                      "Temperatur",
                      temperatureValue != null ? "Heute: $pulseValue  C°" : "~",
                      temperatureValue != null
                          ? temperatureValue == "~"
                              ? "Bitte tägliche Messung durchführen"
                              : "Tägliche Messung  erfolgreich übermittelt"
                          : "Warten Sie mal",
                      temperatureValue == "~" ? 10 : 20),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/measurement-result-temperature');
                  },
                ),
                GestureDetector(
                  child: CustomListComponent(
                      Icons.air,
                      "Sauerstoffsättigung",
                      saturationValue != null
                          ? "Heute: $saturationValue  %"
                          : "~",
                      saturationValue != null
                          ? saturationValue == "~"
                              ? "Bitte tägliche Messung durchführen"
                              : "Tägliche Messung  erfolgreich übermittelt"
                          : "Warten Sie mal",
                      saturationValue == "~" ? 10 : 20),
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
