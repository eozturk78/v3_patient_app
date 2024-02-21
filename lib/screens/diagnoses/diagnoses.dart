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
    onGetDiagnoses();
  }

  onGetDiagnoses() {
    apis.getPatientDiagnoses().then(
      (value) {
        setState(() {
          isStarted = false;
          diagnoseList =
              (value as List).map((e) => PatientDiagnose.fromJson(e)).toList();
        });
      },
      onError: (err) {
        sh.redirectPatient(err, context);
        setState(
          () {
            isStarted = false;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leading('Meine Diagnosen', context),
      body: SafeArea(
          // Wrap your body with SafeArea
          child: SingleChildScrollView(
              child: Center(
                  child: Padding(
        padding: const EdgeInsets.all(15),
        child: isStarted
            ? CircularProgressIndicator(
                color: mainButtonColor,
              )
            : diagnoseList!.isEmpty
                ? Center(child: Text("Keine Daten gefunden"))
                : ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        diagnoseList![index].isExpanded = !diagnoseList![index].isExpanded!;
                      });
                    },
                    children: [
                        for (var item in diagnoseList!)
                          ExpansionPanel(
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              return ListTile(
                                title: Row(
                                  children: [
                                    Icon(
                                      Icons.medical_services_outlined,
                                      color: iconColor,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                        child: Text(
                                      item.diagnoseName,
                                      overflow: TextOverflow.ellipsis,
                                    ))
                                  ],
                                ),
                                subtitle: Column(
                                  mainAxisAlignment:MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height:5),
                                     Text(item.doctor ?? ""),
                                    SizedBox(height:5),
                                    Text(sh.formatDateTime(
                                        item.createdAt.toString())),]
                                ) 
                              );
                            },
                            body: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(item.diagnoseName ?? ""),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(item.subDiagnoseName ?? ""),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Wrap(
                                    runSpacing: 5.0,
                                    spacing: 5.0,
                                    children: [
                                      if (item.securedDiagnoseG == 1)
                                        Text("gesicherte Diagnose (G)",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey)),
                                      if (item.suspicionV == 1)
                                        Text("Verdacht (V)",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey)),
                                      if (item.exclusionA == 1)
                                        Text("Ausschluss (A)",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey)),
                                      if (item.stateAfter == 1)
                                        Text("Zustand nach (Z.n)",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                            ),
                            isExpanded: item.isExpanded ?? false,
                          )
                      ]),
      )))), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 3),
    );
  }
}
