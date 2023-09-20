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
      sh.redirectPatient(err, context);
      setState(() {
        print(err);
        isStarted = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Medikamentenplan', context),
      body: SafeArea(
          // Wrap your body with SafeArea
          child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: isStarted
                ? CircularProgressIndicator(
                    color: mainButtonColor,
                  )
                : mpLis.isEmpty
                    ? Center(child: Text("no data found"))
                    : ExpansionPanelList(
                        expansionCallback: (int index, bool isExpanded) {
                          setState(() {
                            mpLis[index].isExpanded = !isExpanded;
                          });
                        },
                        children: [
                            for (var item in mpLis!)
                              ExpansionPanel(
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return ListTile(
                                    title: Row(
                                      children: [
                                        Icon(
                                          Icons.picture_as_pdf,
                                          color: iconColor,
                                          size: 30,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            item.mpName,
                                            overflow: TextOverflow.ellipsis,
                                            style: item.isExpanded
                                                ? TextStyle(
                                                    color: iconColor,
                                                    fontWeight: FontWeight.bold)
                                                : TextStyle(
                                                    color: const Color.fromARGB(
                                                        255, 75, 74, 74),
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Text(item.updatedBy ?? ""),
                                        Spacer(),
                                        Text(sh.formatDateTime(
                                            item.createdAt.toString())),
                                      ],
                                    ),
                                  );
                                },
                                body: Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      for (var mpr in item.rows)
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Divider(),
                                            Text(
                                              mpr.activeingredient,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            Text(
                                              mpr.commercialname,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Text(mpr.form),
                                                Text(' / '),
                                                Text(mpr.applicationform)
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Table(children: [
                                              TableRow(
                                                children: [
                                                  Center(
                                                    child: Text(
                                                      'morgens',
                                                      style: labelText,
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      'mittag',
                                                      style: labelText,
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      'abend',
                                                      style: labelText,
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      'nacht',
                                                      style: labelText,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              TableRow(children: [
                                                Center(
                                                  child: Text(mpr.doseearly),
                                                ),
                                                Center(
                                                  child: Text(mpr.dosenoon),
                                                ),
                                                Center(
                                                  child:
                                                      Text(mpr.doseafternoon),
                                                ),
                                                Center(
                                                  child: Text(mpr.doseevening),
                                                ),
                                              ])
                                            ]),
                                            Divider(),
                                          ],
                                        ),
                                      TextButton(
                                        onPressed: () async {
                                          await launch(
                                              '${apis.apiPublic}/medicalplan-pdf?treatmentid=${item.treatmentId}');
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.download,
                                              color: iconColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Datei herunterladen',
                                              style: TextStyle(
                                                  color: iconColor,
                                                  fontSize: 16),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                isExpanded: item.isExpanded,
                              )
                          ]),
          ),
        ),
      )), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 2),
    );
  }
}
