import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/message-list-container.dart';
import 'package:patient_app/screens/shared/shared.dart';

import '../../apis/apis.dart';
import '../../colors/colors.dart';
import '../../model/message-notification.dart';
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
  Shared sh = Shared();
  bool isStarted = true;
  @override
  void initState() {
    super.initState();
    setState(() {
      isStarted = isStarted;
    });
    apis.getPatientNotificationList().then(
        (resp) => {
              setState(() {
                notificationList = (resp as List)
                    .map((e) => MessageNotification.fromJson(e))
                    .toList();
                isStarted = false;
              }),
            }, onError: (err) {
      setState(() {
        isStarted = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Mitteilungen!', context),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: isStarted
            ? CircularProgressIndicator(
                color: mainButtonColor,
              )
            : notificationList.isEmpty
                ? Center(child: Text("no data found"))
                : Column(
                    children: [
                      Text("Hier können Sie Ihre Mitteilungen einsehen."),
                      TextFormField(
                        obscureText: false,
                        decoration: const InputDecoration(
                          labelText: 'Suchen',
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Column(
                        children: [
                          for (var element in notificationList)
                            GestureDetector(
                              child: CustomMessageListContainer(
                                  Icons.info,
                                  element.notificationTitle.length > 22
                                      ? element.notificationTitle
                                          .substring(0, 22)
                                      : element.notificationTitle,
                                  sh.formatDateTime(element.createdAt)),
                              onTap: () {
                                Navigator.of(context).pushNamed('/chat');
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
      ),
      bottomNavigationBar: BottomNavigatorBar(1),
    );
  }
}
