import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/message-list-container.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:patient_app/shared/shared.dart';

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
  }

  getNotification(notification) async {
    setState(() {
      isStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    notification =
        ModalRoute.of(context)!.settings.arguments as MessageNotification;
    getNotification(notification);
    return Scaffold(
      appBar: leadingSubpage('Nachrichten!', context),
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
      bottomNavigationBar: BottomNavigatorBar(1),
    );
  }
}
