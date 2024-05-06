import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:patient_app/shared/shared.dart';
import 'package:patient_app/shared/toast.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../apis/apis.dart';
import '../shared/bottom-menu.dart';
import '../shared/sub-total.dart';
import 'package:badges/badges.dart' as badges;

class CommunicationPage extends StatefulWidget {
  const CommunicationPage({super.key});

  @override
  State<CommunicationPage> createState() => _CommunicationPageState();
}

class _CommunicationPageState extends State<CommunicationPage> {
  Apis apis = Apis();
  DateTime today = DateTime.now();
  String? videoUrl;
  Shared sh = Shared();
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
    }, onError: (err) {
      sh.redirectPatient(err, context);
    });
    sh.openPopUp(context, 'communication');
    getUnReadMessageCount();
  }

  bool loading = true;
  getUnReadMessageCount() {
    Apis apis = Apis();
    apis.getUnReadMessageCount().then((value) {
      setState(() {
        unreadMessageCount = value['unreadmessagecount'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage(sh.getLanguageResource("communication"), context),
      body: SafeArea(
        // Wrap your body with SafeArea
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              verticalDirection: VerticalDirection.down,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: ResponsiveGridRow(
                    children: [
                      ResponsiveGridCol(
                        lg: 3,
                        xs: 6,
                        md: 3,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 0),
                          child: badges.Badge(
                            badgeStyle: badges.BadgeStyle(
                                padding: EdgeInsets.all(7),
                                badgeColor: unreadMessageCount == 0 ||
                                        unreadMessageCount == "0" ||
                                        unreadMessageCount == null
                                    ? Colors.transparent
                                    : Colors.red),
                            badgeContent: Text(
                              unreadMessageCount.toString(),
                              style: TextStyle(
                                  color: unreadMessageCount == 0 ||
                                          unreadMessageCount == "0" ||
                                          unreadMessageCount == null
                                      ? Colors.transparent
                                      : Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            child: GestureDetector(
                              child: CustomSubTotal(
                                  SvgPicture.asset(
                                      'assets/images/menu-icons/mitteilungen-main.svg'),
                                  sh.getLanguageResource("notifications"),
                                  null,
                                  null,
                                  10),
                              onTap: () {
                                Navigator.of(context).pushNamed('/messages');
                              },
                            ),
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        lg: 2,
                        xs: 6,
                        md: 3,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: GestureDetector(
                            child: CustomSubTotal(
                                SvgPicture.asset(
                                    'assets/images/menu-icons/erinnerungen-main.svg'),
                                sh.getLanguageResource("memories"),
                                null,
                                null,
                                10),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed('/notification-history')
                                  .then((value) => getUnReadMessageCount());
                            },
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        lg: 2,
                        xs: 6,
                        md: 3,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: GestureDetector(
                            child: CustomSubTotal(
                                Icons.video_call,
                                sh.getLanguageResource("video_consultation"),
                                null,
                                null,
                                20),
                            onTap: () async {
                              if (videoUrl != null) {
                                await launch(videoUrl!);
                              } else {
                                showToast(sh.getLanguageResource(
                                    "no_video_consultation_event"));
                              }
                            },
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        lg: 2,
                        xs: 6,
                        md: 3,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: GestureDetector(
                            child: CustomSubTotal(
                                Icons.calendar_month_outlined,
                                sh.getLanguageResource("calendar"),
                                null,
                                null,
                                10),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed('/calendar')
                                  .then((value) => getUnReadMessageCount());
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 3),
    );
  }
}
