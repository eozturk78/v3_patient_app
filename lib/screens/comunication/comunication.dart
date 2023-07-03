import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';

import '../shared/bottom-menu.dart';
import '../shared/sub-total.dart';

class ComunicationPage extends StatefulWidget {
  const ComunicationPage({super.key});

  @override
  State<ComunicationPage> createState() => _ComunicationPageState();
}

class _ComunicationPageState extends State<ComunicationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leading('Kommunikation!', context),
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
                Spacer(),
                GestureDetector(
                  child: const CustomSubTotal(
                      Icons.video_call, "Videosprechstunde", null, null, 20),
                  onTap: () {},
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
      bottomNavigationBar: BottomNavigatorBar(1),
    );
  }
}
