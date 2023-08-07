import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../apis/apis.dart';
import '../shared/bottom-menu.dart';
import '../shared/sub-total.dart';

class CommunicationPage extends StatefulWidget {
  const CommunicationPage({super.key});

  @override
  State<CommunicationPage> createState() => _CommunicationPageState();
}

class _CommunicationPageState extends State<CommunicationPage> {
  Apis apis = Apis();
  DateTime today = DateTime.now();
  String? videoUrl;
  @override
  void initState() {
    super.initState();
    today = today.add(const Duration(hours: -1));
    apis.getPatientOnlineMeetingEvents().then((resp) {
      for (var element in resp) {
        var meetingDate = DateTime.parse(element['meeting_date']);
        // ignore: unrelated_type_equality_checks
        if (today.compareTo(meetingDate) < 0) {
          videoUrl = element['meeting_link'];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leading('Kommunikation', context),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: [
            Row(
              children: [
                GestureDetector(
                  child: const CustomSubTotal(Icons.chat_bubble_outline_rounded,
                      "Mitteilungen", null, null, 10),
                  onTap: () {
                    Navigator.of(context).pushNamed('/messages');
                  },
                ),
                const Spacer(),
                GestureDetector(
                  child: const CustomSubTotal(
                      Icons.video_call, "Videosprechstunde", null, null, 20),
                  onTap: () async {
                    if (videoUrl != null) await launch(videoUrl!);
                  },
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: const CustomSubTotal(Icons.calendar_month_outlined,
                      "Kalender", null, null, 10),
                  onTap: () {
                    Navigator.of(context).pushNamed('/calendar');
                  },
                ),
              ],
            ),
          ],
        ),
      )), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: const BottomNavigatorBar(1),
    );
  }
}
