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
      appBar: leadingWithoutBack('Infothek', context),
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
                      Icons.book_online_outlined, "Bibliothek", null, null, 10),
                  onTap: () {
                    Navigator.of(context).pushNamed('/libraries');
                  },
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  child: CustomSubTotal(Icons.text_snippet_outlined,
                      "Meine Dokumente", null, null, 10),
                  onTap: () {
                    Navigator.of(context).pushNamed('/documents');
                  },
                ),
                Spacer(),
                GestureDetector(
                  child: CustomSubTotal(Icons.medical_information_outlined,
                      "Aufklärung", null, null, 10),
                  onTap: () {
                    Navigator.of(context).pushNamed('/enlightenment');
                  },
                ),
              ],
            ),
          ],
        ),
      ))), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 4),
    );
  }
}
