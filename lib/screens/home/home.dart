import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../shared/bottom-menu.dart';
import '../../shared/shared.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Apis apis = Apis();
  Shared sh = Shared();
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

  int? allQuentionnaireFilled = 0;
  getMainData() {
    setState(() {
      allQuentionnaireFilled = 0;
    });
    apis.getpatientmaindata().then((resp) {
      if (resp != null) {
        print(resp);
        setState(() {
          bloodPressureValue = resp['bloodPressureValue'] != null
              ? resp['bloodPressureValue']
              : "~";
          pulseValue =
              resp['pulseValue'] != null ? resp['pulseValue'].toString() : "~";
          saturationValue = resp['saturationValue'] != null
              ? resp['saturationValue'].toString()
              : "~";
          temperatureValue = resp['temperatureValue'] != null
              ? resp['temperatureValue'].toString()
              : "~";
          weightValue = resp['weightValue'] != null
              ? resp['weightValue'].toString()
              : "~";

          if (resp['bloodPressureValue'] != null &&
              resp['pulseValue'] != null &&
              resp['saturationValue'] != null &&
              resp['temperatureValue'] != null &&
              resp['weightValue'] != null) {
            setState(() {
              allQuentionnaireFilled = 10;
            });
          } else {
            setState(() {
              allQuentionnaireFilled = 20;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalObjectKey<ExpandableFabState>(context);
    return Scaffold(
      appBar: leadingSubpage(
          sh.getLanguageResource("graph_representation"), context),
      body: SafeArea(
        // Wrap your body with SafeArea
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            width: double.infinity,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: CustomListComponent(
                      Icons.area_chart,
                      sh.getLanguageResource("blood_pressure"),
                      bloodPressureValue != null
                          ? "${sh.getLanguageResource('today')} : $bloodPressureValue mmHg"
                          : "~",
                      bloodPressureValue != null
                          ? bloodPressureValue == "~"
                              ? sh.getLanguageResource(
                                  "perform_daily_mesaurement")
                              : sh.getLanguageResource(
                                  "daily_measurement_successfully_sent")
                          : sh.getLanguageResource("loading"),
                      bloodPressureValue == "~" ? 10 : 20),
                  onTap: () {
                    Navigator.of(context).pushNamed('/measurement-result');
                  },
                ),
                Divider(),
                GestureDetector(
                  child: CustomListComponent(
                      Icons.monitor_weight_outlined,
                      sh.getLanguageResource("weight"),
                      weightValue != null
                          ? "${sh.getLanguageResource("today")}: $weightValue kg"
                          : "~",
                      weightValue != null
                          ? weightValue == "~"
                              ? sh.getLanguageResource(
                                  "perform_daily_mesaurement")
                              : sh.getLanguageResource(
                                  "daily_measurement_successfully_sent")
                          : sh.getLanguageResource("loading"),
                      weightValue == "~" ? 10 : 20),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/measurement-result-weight');
                  },
                ),
                Divider(),
                GestureDetector(
                  child: CustomListComponent(
                      Icons.monitor_heart_outlined,
                      sh.getLanguageResource("pulse"),
                      pulseValue != null
                          ? "${sh.getLanguageResource("today")}: $pulseValue bpm"
                          : "~",
                      pulseValue != null
                          ? pulseValue == "~"
                              ? sh.getLanguageResource(
                                  "perform_daily_mesaurement")
                              : sh.getLanguageResource(
                                  "daily_measurement_successfully_sent")
                          : sh.getLanguageResource("loading"),
                      pulseValue == "~" ? 10 : 20),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/measurement-result-pulse');
                  },
                ),
                Divider(),
                GestureDetector(
                  child: CustomListComponent(
                      Icons.thermostat,
                      sh.getLanguageResource("temperature"),
                      temperatureValue != null
                          ? "${sh.getLanguageResource("today")}: $temperatureValue  C°"
                          : "~",
                      temperatureValue != null
                          ? temperatureValue == "~"
                              ? sh.getLanguageResource(
                                  "perform_daily_mesaurement")
                              : sh.getLanguageResource(
                                  "daily_measurement_successfully_sent")
                          : sh.getLanguageResource("loading"),
                      temperatureValue == "~" ? 10 : 20),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/measurement-result-temperature');
                  },
                ),
                Divider(),
                GestureDetector(
                  child: CustomListComponent(
                      Icons.air,
                      sh.getLanguageResource("oxygen_saturation"),
                      saturationValue != null
                          ? "${sh.getLanguageResource("today")}: $saturationValue  %"
                          : "~",
                      saturationValue != null
                          ? saturationValue == "~"
                              ? sh.getLanguageResource(
                                  "perform_daily_mesaurement")
                              : sh.getLanguageResource(
                                  "daily_measurement_successfully_sent")
                          : sh.getLanguageResource("loading"),
                      saturationValue == "~" ? 10 : 20),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/measurement-result-saturation');
                  },
                ),
                Divider(),
                GestureDetector(
                  child: CustomListComponent(
                      Icons.question_mark_outlined,
                      sh.getLanguageResource("questionnaire"),
                      null,
                      allQuentionnaireFilled != 0
                          ? allQuentionnaireFilled == 20
                              ? sh.getLanguageResource(
                                  "perform_daily_mesaurement")
                              : sh.getLanguageResource(
                                  "daily_measurement_successfully_sent")
                          : sh.getLanguageResource("loading"),
                      allQuentionnaireFilled == 20 ? 10 : 20),
                  onTap: () {
                    Navigator.of(context).pushNamed('/questionnaire-group');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 0),
    );
  }
}
