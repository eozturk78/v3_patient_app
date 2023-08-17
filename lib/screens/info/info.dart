import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';

import '../shared/bottom-menu.dart';
import '../shared/sub-total.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leading('Infothek', context),
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
                  child: const CustomSubTotal(
                      Icons.book_online_outlined, "Bibliothek", null, null, 10),
                  onTap: () {
                    Navigator.of(context).pushNamed('/libraries');
                  },
                ),
                Spacer(),
                GestureDetector(
                  child: const CustomSubTotal(
                      Icons.medical_information_outlined,
                      "Aufklärung",
                      null,
                      null,
                      10),
                  onTap: () {
                    Navigator.of(context).pushNamed('/enlightenment');
                  },
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: const CustomSubTotal(Icons.text_snippet_outlined,
                      "Meine Dokumente", null, null, 10),
                  onTap: () {
                    Navigator.of(context).pushNamed('/documents');
                  },
                ),
              ],
            ),
          ],
        ),
      )), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(3),
    );
  }
}
