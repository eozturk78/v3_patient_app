import 'dart:async';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
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

  PDFDocument? document;
  bool isStarted = true;
  @override
  void initState() {
    super.initState();
    sh.openPopUp(context, 'medication-plan-list');
    fnGetMedicalPlanList();
  }

  fnGetMedicalPlanList() {
    setState(() {
      isStarted = true;
    });
    apis.getPatientMedicalPlanList().then((value) {
      setState(() {
        mpLis = (value as List).map((e) => MedicalPlan.fromJson(e)).toList();
        isStarted = false;
      });
    }, onError: (err) {
      sh.redirectPatient(err, context);
      setState(() {
        isStarted = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage(sh.getLanguageResource("medical_plan"), context),
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
                    ? Center(
                        child: Text(sh.getLanguageResource("no_data_found")))
                    : ExpansionPanelList(
                        expansionCallback: (int index, bool isExpanded) {
                          setState(() {
                            mpLis[index].isExpanded = !mpLis[index].isExpanded;
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
                                            "${sh.getLanguageResource("medical_plan")}_${item.versionNumber}",
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
                                  padding: EdgeInsets.only(left: 5, right: 5),
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
                                              style: mpBoldText,
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
                                                      sh.getLanguageResource(
                                                          "morning_mp"),
                                                      style: mpBoldText,
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      sh.getLanguageResource(
                                                          "noon_mp"),
                                                      style: mpBoldText,
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      sh.getLanguageResource(
                                                          "evening_mp"),
                                                      style: mpBoldText,
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      sh.getLanguageResource(
                                                          "night_mp"),
                                                      style: mpBoldText,
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
                                          var url =
                                              '${apis.apiPublic}/medicalplan-pdf-file?treatmentid=${item.treatmentId}&versionno=${item.versionNumber}';

                                          PDFDocument.fromURL(url)
                                              .then((value) {
                                            setState(() {
                                              showDialog(
                                                context: context,
                                                builder: (context) => onOpenImage2(
                                                    context,
                                                    value,
                                                    "${sh.getLanguageResource("medical_plan")}_${item.versionNumber}"),
                                              );
                                            });
                                          });
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
                                              sh.getLanguageResource(
                                                  "download_file"),
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

Widget onOpenImage2(BuildContext context, PDFDocument document, String name) {
  return AlertDialog(
    insetPadding: EdgeInsets.symmetric(
      horizontal: 0,
      vertical: 0,
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: 0,
      vertical: 0,
    ),
    content: StatefulBuilder(
      builder: (BuildContext context, setState) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.close,
                        size: 30,
                      ),
                    ),
                    Spacer(),
                    Text(name),
                    Spacer(),
                  ],
                ),
                height: 40,
                padding: EdgeInsets.only(right: 10, left: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.84,
                width: double.infinity,
                child: PDFViewer(
                  scrollDirection: Axis.vertical,
                  document: document!,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
