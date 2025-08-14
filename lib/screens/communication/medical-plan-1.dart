import 'dart:async';

import 'package:flutter/material.dart';
import 'package:v3_patient_app/screens/main-menu/main-menu.dart';
import 'package:v3_patient_app/screens/shared/list-box.dart';
import 'package:v3_patient_app/screens/shared/message-list-container.dart';
import 'package:v3_patient_app/screens/shared/shared.dart';
import 'package:v3_patient_app/shared/shared.dart';

import '../../colors/colors.dart';
import '../../model/message-notification.dart';
import '../shared/bottom-menu.dart';
import '../shared/message-text-bubble.dart';

class MedicalPlan1Page extends StatefulWidget {
  const MedicalPlan1Page({Key? key}) : super(key: key);

  @override
  State<MedicalPlan1Page> createState() => _MedicalPlan1PageState();
}

class _MedicalPlan1PageState extends State<MedicalPlan1Page> {
  late MessageNotification notification;
  Shared sh = Shared();
  bool isStarted = true;

  @override
  void initState() {
    super.initState();
    sh.openPopUp(context, 'medical-plan-1');
  }

  getNotification(notification) async {
    setState(() {
      isStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    notification = chosenMedicationPlan!;
    getNotification(notification);
    return Scaffold(
      appBar: leadingSubpage('Nachrichten', context),
      body: SingleChildScrollView(
        child: Center(
          child: isStarted
              ? Center(
                  child: CircularProgressIndicator(
                    color: mainButtonColor,
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(15),
                  child: CustomMessageTextBubble(
                    dateTime: sh.formatDateTime(notification.createdAt),
                    senderTitle: notification.createdBy ?? "",
                    text: notification.notificationContent,
                    senderType: 10,
                    image: notification.attachment,
                    messageType: 10,
                  ),
                ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
      ////bottomNavigationBar: BottomNavigatorBar(selectedIndex: 3),
    );
  }
}
