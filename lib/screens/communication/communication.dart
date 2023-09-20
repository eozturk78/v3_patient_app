import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:patient_app/shared/toast.dart';
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
    apis.getPatientOnlineMeetings().then((resp) {
      for (var element in resp) {
        try {
          var meetingDate = DateTime.parse(element['meeting_date']);
          // ignore: unrelated_type_equality_checks
          if (today.compareTo(meetingDate) < 0) {
            videoUrl = element['meeting_link'];
          }
        } catch (e) {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingWithoutBack('Nachrichten', context),
      body: SafeArea(
          // Wrap your body with SafeArea
          child: Center(
              child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: [
            Row(
              children: [
                GestureDetector(
                  child: CustomSubTotal(
                      SvgPicture.asset(
                          'assets/images/menu-icons/mitteilungen-main.svg'),
                      "Mitteilungen",
                      null,
                      null,
                      10),
                  onTap: () {
                    Navigator.of(context).pushNamed('/messages');
                  },
                ),
                const Spacer(),
                GestureDetector(
                  child: CustomSubTotal(
                      SvgPicture.asset(
                          'assets/images/menu-icons/erinnerungen-main.svg'),
                      "Erinnerungen",
                      null,
                      null,
                      10),
                  onTap: () {
                    Navigator.of(context).pushNamed('/notification-history');
                  },
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  child: CustomSubTotal(
                      Icons.video_call, "Videosprechstunde", null, null, 20),
                  onTap: () async {
                    if (videoUrl != null) {
                      await launch(videoUrl!);
                    } else {
                      showToast(
                          "Derzeit ist kein Treffen verfügbar. Bitte versuchen Sie es noch einmal mit der Besprechungszeit!");
                    }
                  },
                ),
                const Spacer(),
                GestureDetector(
                  child: CustomSubTotal(Icons.calendar_month_outlined,
                      "Kalender", null, null, 10),
                  onTap: () {
                    Navigator.of(context).pushNamed('/calendar');
                  },
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),
          ],
        ),
      ))), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 3),
    );
  }
}
