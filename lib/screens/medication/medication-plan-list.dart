import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/apis/apis.dart';
import 'package:patient_app/model/medical-plan.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../colors/colors.dart';
import '../../shared/shared.dart';
import '../shared/bottom-menu.dart';
import '../shared/medication-plan-box.dart';

class MedicationPlanListPage extends StatefulWidget {
  const MedicationPlanListPage({super.key});

  @override
  State<MedicationPlanListPage> createState() => _MedicationPlanListPageState();
}

class _MedicationPlanListPageState extends State<MedicationPlanListPage> {
  Apis apis = Apis();
  Shared sh = Shared();
  List<MedicalPlan> mpLis = [];
  bool isStarted = true;
  @override
  void initState() {
    super.initState();
    fnGetMedicalPlanList();
  }

  fnGetMedicalPlanList() {
    setState(() {
      isStarted = true;
    });
    apis.getPatientMedicalPlanList().then((value) {
      setState(() {
        print(value);
        mpLis = (value as List).map((e) => MedicalPlan.fromJson(e)).toList();
        isStarted = false;
      });
    }, onError: (err) {
      setState(() {
        print(err);
        isStarted = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Medikamentenplan!', context),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: isStarted
                ? CircularProgressIndicator(
                    color: mainButtonColor,
                  )
                : mpLis.isEmpty
                    ? Center(child: Text("no data found"))
                    : Column(
                        children: [
                          for (var element in mpLis)
                            GestureDetector(
                                onTap: () async {
                                  await launch(
                                      '${apis.apiPublic}/medicalplan-pdf?treatmentid=${element.treatmentId}');
                                },
                                child: CustomMedicationPlanBox(
                                    "Medikamentenplan_02_${sh.formatDate(element.createdAt)}",
                                    element.createdAt != null
                                        ? sh.formatDate(element.createdAt)
                                        : "",
                                    element.updatedBy))
                        ],
                      ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(2),
    );
  }
}
