import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:patient_app/screens/shared/message-list-container.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      isStarted = true;
    });
    apis.getPatientNotificationList().then(
        (resp) => {
              setState(() {
                notificationList = (resp as List)
                    .map((e) => MessageNotification.fromJson(e))
                    .toList();
                notificationList
                    .sort((a, b) => b.createdAt.compareTo(a.createdAt));
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
    final key = GlobalObjectKey<ExpandableFabState>(context);
    return Scaffold(
      appBar: leadingSubpage('Mitteilungen!', context),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
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
                                  onTap: () async {
                                    if (element.notificationtype == 10) {
                                      Navigator.pushNamed(
                                          context, '/medical-plan-1',
                                          arguments: element);
                                    } else {
                                      SharedPreferences pref =
                                          await SharedPreferences.getInstance();
                                      pref.setString(
                                          "thread", element.thread ?? "");
                                      Navigator.pushNamed(context, '/chat');
                                    }
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
          ),
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: key,
        // duration: const Duration(seconds: 1),
        distance: 60.0,
        type: ExpandableFabType.up,
        // fanAngle: 70,
        child: const Icon(Icons.add),
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
          FloatingActionButton.extended(
            onPressed: () => {},
            icon: new Icon(Icons.image),
            label: Text("Fotogalerie"),
          ),
          FloatingActionButton.extended(
            onPressed: () => {
              // フローティングアクションボタンを押された時の処理.
            },
            icon: new Icon(Icons.image),
            label: Text("Foto aufnehmen"),
          ),
          FloatingActionButton.extended(
            onPressed: () => {
              // フローティングアクションボタンを押された時の処理.
            },
            icon: new Icon(Icons.image),
            label: Text("Datei auswählen"),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigatorBar(1),
    );
  }
}
