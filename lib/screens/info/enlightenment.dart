import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../shared/bottom-menu.dart';
import '../shared/library-box.dart';
import '../shared/medication-plan-box.dart';

class EnlightenmentPage extends StatefulWidget {
  const EnlightenmentPage({super.key});

  @override
  State<EnlightenmentPage> createState() => _EnlightenmentPageState();
}

class _EnlightenmentPageState extends State<EnlightenmentPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Aufklärung', context),
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      onOpenImage(context, "assets/images/enlightenment-1.jpg"),
                ).then((value) {});
              },
              child: Image.asset(
                "assets/images/enlightenment-1.jpg",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      onOpenImage(context, "assets/images/enlightenment-2.jpg"),
                ).then((value) {});
              },
              child: Image.asset(
                "assets/images/enlightenment-2.jpg",
              ),
            )
          ],
        ),
      )), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(3),
    );
  }

  Widget onOpenImage(BuildContext context, String imageText) {
    return AlertDialog(
      content: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Container(
            width: MediaQuery.of(context).size.width * 1,
            height: 300,
            child: PhotoView(
              imageProvider: AssetImage(imageText),
            ),
          );
        },
      ),
    );
  }
}
