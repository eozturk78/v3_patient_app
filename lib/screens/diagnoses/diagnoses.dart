import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/apis/apis.dart';
import 'package:patient_app/model/diagnose.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';

import '../../colors/colors.dart';
import '../../shared/shared.dart';
import '../shared/bottom-menu.dart';
import '../shared/diagnose-box.dart';
import '../shared/sub-total.dart';

class DiagnosesPage extends StatefulWidget {
  const DiagnosesPage({super.key});

  @override
  State<DiagnosesPage> createState() => _DiagnosesPageState();
}

class _DiagnosesPageState extends State<DiagnosesPage> {
  Apis apis = Apis();
  Shared sh = Shared();
  List<PatientDiagnose> diagnoseList = [];
  bool isStarted = true;
  @override
  void initState() {
    super.initState();
    onGetRecipes();
  }

  onGetRecipes() {
    apis.getPatientDiagnoses().then((value) {
      setState(() {
        isStarted = false;
        print(value);
        diagnoseList =
            (value as List).map((e) => PatientDiagnose.fromJson(e)).toList();
      });
    }, onError: (err) {
      setState(() {
        isStarted = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leading('Meine Diagnosen', context),
      body: SafeArea( // Wrap your body with SafeArea
      child: SingleChildScrollView(
          child: Center(
              child: Padding(
        padding: const EdgeInsets.all(15),
        child: isStarted
            ? CircularProgressIndicator(
                color: mainButtonColor,
              )
            : diagnoseList!.isEmpty
                ? Center(child: Text("no data found"))
                : Column(
                    children: [
                      for (var element in diagnoseList)
                        CustomDiagnoseBox(
                            element.diagnoseName,
                            element.subDiagnoseName ?? "",
                            element.securedDiagnoseG,
                            element.suspicionV,
                            element.exclusionA,
                            element.diaLeft,
                            element.diaRight,
                            element.bothSide,
                            element.createdAt,
                            element.stateAfter,
                            element.doctor ?? "")
                    ],
                  ),
      )))), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 3),
    );
  }
}
