import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:patient_app/model/patient-group.dart';
import 'package:patient_app/screens/main-menu/main-menu.dart';
import 'package:patient_app/screens/shared/message-list-container.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:badges/badges.dart' as badges;
import '../../apis/apis.dart';
import '../../colors/colors.dart';
import '../../model/message-notification.dart';
import '../../model/organization.dart';
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
  List<Organization> organizations = [];
  int fpType = 20;
  @override
  void initState() {
    super.initState();
    setState(() {
      fpType = 20;
      isStarted = true;
    });
    getNotificationList();
    sh.openPopUp(context, 'messages');
  }

  getNotificationList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('organizations') != null) {
      organizations = (jsonDecode(pref.getString('organizations')!) as List)
          .map((e) => Organization.fromJson(e))
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
      appBar: leadingSubpage(sh.getLanguageResource("notifications"), context),
      body: Container(
        padding: EdgeInsets.only(top: 30),
        child: isStarted
            ? Center(
                child: CircularProgressIndicator(
                  color: mainButtonColor,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                children: [
                  Text(
                    sh.getLanguageResource("view_your_message"),
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
                                  value: 0.3,
                                ),
                              ],
                            ).value!,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: fpType == 20
                                  ? mainButtonColor
                                  : mainItemColor,
                            ),
                            onPressed: () {
                              setState(() {
                                fpType = 20;
                              });
                            },
                            child: Text(
                              sh.getLanguageResource("messages"),
                              style: TextStyle(color: Colors.white),
                            )),
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
                                  value: 0.3,
                                ),
                              ],
                            ).value!,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: fpType == 10
                                  ? mainButtonColor
                                  : mainItemColor,
                            ),
                            onPressed: () {
                              setState(() {
                                fpType = 10;
                              });
                            },
                            child: Text(
                              sh.getLanguageResource("medical_plan_list"),
                            )),
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
                          child: notificationList
                                  .where((element) =>
                                      element.notificationtype == fpType)
                                  .isEmpty
                              ? Center(
                                  child: Text(
                                  sh.getLanguageResource("no_data_found"),
                                ))
                              : Column(
                                  children: [
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Column(
                                      children: [
                                        for (var element in notificationList)
                                          if (element.notificationtype ==
                                              fpType)
                                            badges.Badge(
                                              badgeStyle: badges.BadgeStyle(
                                                  padding: EdgeInsets.all(7),
                                                  badgeColor:
                                                      element.isRead == 0
                                                          ? Colors.transparent
                                                          : Colors.red),
                                              badgeContent: element.isRead != 0
                                                  ? Text(
                                                      element.isRead.toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : null,
                                              child: GestureDetector(
                                                child:
                                                    CustomMessageListContainer(
                                                  Icons.info,
                                                  element.notificationTitle
                                                              .length >
                                                          22
                                                      ? element
                                                          .notificationTitle
                                                          .substring(0, 22)
                                                      : element
                                                          .notificationTitle,
                                                  sh.formatDateTime(
                                                      element.createdAt),
                                                  null,
                                                ),
                                                onTap: () async {
                                                  if (element
                                                          .notificationtype ==
                                                      10) {
                                                    Navigator.pushNamed(navContext,
                                                        '/medical-plan-1',
                                                        arguments: element);
                                                  } else {
                                                    SharedPreferences pref =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    pref.setString(
                                                        "organization",
                                                        element.organization ??
                                                            "");
                                                    pref.setString("thread",
                                                        element.thread ?? "");

                                                    Navigator.pushNamed(
                                                            context, '/chat')
                                                        .then((value) =>
                                                            getNotificationList());
                                                  }
                                                },
                                              ),
                                            )
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
          for (var item in organizations)
            FloatingActionButton.extended(
              heroTag: item.organization+item.name+item.hashCode.toString(),
              onPressed: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();

                pref.setString("organization", item.organization);

                pref.remove('thread');
                var thread = threadList
                            .where((element) =>
                                element.organization == item.organization)
                            .length >
                        0
                    ? threadList
                        .where((element) =>
                            element.organization == item.organization)
                        .first
                    : null;

                if (thread != null)
                  pref.setString('thread', thread.thread.toString());

                Navigator.pushNamed(context, '/chat');
              },
              icon: new Icon(Icons.medical_information),
              label: Text(item.name),
            ),
        ],
      ),
      ////bottomNavigationBar: BottomNavigatorBar(selectedIndex: 3),
    );
  }
}
