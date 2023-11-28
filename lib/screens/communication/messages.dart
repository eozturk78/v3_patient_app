import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:patient_app/model/patient-group.dart';
import 'package:patient_app/screens/shared/message-list-container.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../../colors/colors.dart';
import '../../model/message-notification.dart';
import '../../model/scale-size.dart';
import '../../shared/shared.dart';
import '../shared/bottom-menu.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  Apis apis = Apis();
  List<MessageNotification> notificationList = [];
  List<MessageNotification> threadList = [];
  Shared sh = Shared();
  bool isStarted = true;
  List<PatientGroup> patientGroups = [];
  int fpType = 20;
  @override
  void initState() {
    super.initState();
    setState(() {
      fpType = 20;
      isStarted = true;
    });
    getNotificationList();
  }

  getNotificationList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('patientGroups') != null) {
      patientGroups = (jsonDecode(pref.getString('patientGroups')!) as List)
          .map((e) => PatientGroup.fromJson(e))
          .toList();
    }
    apis.getPatientNotificationList().then(
      (resp) => {
        setState(() {
          notificationList = (resp as List)
              .map((e) => MessageNotification.fromJson(e))
              .toList();
          notificationList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          isStarted = false;

          threadList = notificationList
              .where((element) => element.notificationtype != 10)
              .toList();
        }),
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
    final key = GlobalObjectKey<ExpandableFabState>(context);
    return Scaffold(
      appBar: leadingSubpage('Mitteilungen', context),
      body: Container(
        padding: EdgeInsets.only(top: 30),
        child: isStarted
            ? CircularProgressIndicator(
                color: mainButtonColor,
              )
            : notificationList.isEmpty
                ? Center(child: Text("no data found"))
                : SingleChildScrollView(
                    child: Column(
                    children: [
                      Text(
                        "Hier können Sie Ihre Mitteilungen einsehen.",
                        textScaleFactor: ScaleSize.textScaleFactor(context),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width *
                                ResponsiveValue(
                                  context,
                                  defaultValue: 0.40,
                                  conditionalValues: [
                                    Condition.largerThan(
                                      //Tablet
                                      name: MOBILE,
                                      value: 0.2,
                                    ),
                                  ],
                                ).value!,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: fpType == 20
                                      ? mainButtonColor
                                      : mainItemColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    fpType = 20;
                                  });
                                },
                                child: Text("Nachrichten")),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width *
                                ResponsiveValue(
                                  context,
                                  defaultValue: 0.40,
                                  conditionalValues: [
                                    Condition.largerThan(
                                      //Tablet
                                      name: MOBILE,
                                      value: 0.2,
                                    ),
                                  ],
                                ).value!,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: fpType == 10
                                      ? mainButtonColor
                                      : mainItemColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    fpType = 10;
                                  });
                                },
                                child: Text("Medikamentenplan")),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Column(
                                    children: [
                                      for (var element in notificationList)
                                        if (element.notificationtype == fpType)
                                          GestureDetector(
                                            child: CustomMessageListContainer(
                                                Icons.info,
                                                element.notificationTitle
                                                            .length >
                                                        22
                                                    ? element.notificationTitle
                                                        .substring(0, 22)
                                                    : element.notificationTitle,
                                                sh.formatDateTime(
                                                    element.createdAt)),
                                            onTap: () async {
                                              if (element.notificationtype ==
                                                  10) {
                                                Navigator.pushNamed(
                                                    context, '/medical-plan-1',
                                                    arguments: element);
                                              } else {
                                                SharedPreferences pref =
                                                    await SharedPreferences
                                                        .getInstance();
                                                pref.setString("organization",
                                                    element.organization ?? "");
                                                pref.setString("thread",
                                                    element.thread ?? "");
                                                Navigator.pushNamed(
                                                    context, '/chat');
                                              }
                                            },
                                          ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: key,
        // duration: const Duration(seconds: 1),
        distance: 60.0,
        type: ExpandableFabType.up,
        // fanAngle: 70,
        child: Icon(Icons.add),
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
          for (var item in patientGroups)
            FloatingActionButton.extended(
              onPressed: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();

                if (item.links != null && item.links.organization != null) {
                  var org = sh.getBaseName(item.links.organization);
                  pref.setString("organization", org);
                }

                pref.remove('thread');
                var thread = threadList
                            .where((element) =>
                                element.organization ==
                                sh.getBaseName(item.links.organization))
                            .length >
                        0
                    ? threadList
                        .where((element) =>
                            element.organization ==
                            sh.getBaseName(item.links.organization))
                        .first
                    : null;

                print(item.links.organization);
                if (thread != null)
                  pref.setString('thread', thread.thread.toString());

                Navigator.pushNamed(context, '/chat');
              },
              icon: new Icon(Icons.medical_information),
              label: Text(item.name),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 3),
    );
  }
}
