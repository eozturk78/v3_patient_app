import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';

import '../shared/bottom-menu.dart';

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
      appBar: leading('Infothek!', context),
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
                  child: const CustomListComponent(Icons.book_online_outlined,
                      "Medikamentenplan", null, null, 10),
                  onTap: () {
                    Navigator.of(context).pushNamed('/measurement-result');
                  },
                ),
                Spacer(),
                GestureDetector(
                  child: const CustomListComponent(
                      Icons.question_answer_outlined, "FAQ", null, null, 20),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/measurement-result-weight');
                  },
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  child: const CustomListComponent(
                      Icons.medical_information_outlined,
                      "Aufklärung",
                      null,
                      null,
                      10),
                  onTap: () {
                    Navigator.of(context).pushNamed('/measurement-result');
                  },
                ),
                Spacer(),
                GestureDetector(
                  child: const CustomListComponent(Icons.text_snippet_outlined,
                      "Aufklärung", null, null, 10),
                  onTap: () {
                    Navigator.of(context).pushNamed('/measurement-result');
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
