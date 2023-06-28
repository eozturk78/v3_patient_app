import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/message-list-container.dart';
import 'package:patient_app/screens/shared/shared.dart';

import '../shared/bottom-menu.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Mitteilungen!', context),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
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
                GestureDetector(
                  child: const CustomMessageListContainer(Icons.info,
                      "Vielen Dank ! Ich wünsc ...", "23.06.2023 14:45"),
                  onTap: () {
                    Navigator.of(context).pushNamed('/chat');
                  },
                ),
                GestureDetector(
                  child: const CustomMessageListContainer(
                      Icons.info, "Neuer Medikamentenplan", "23.06.2023 13:31"),
                  onTap: () {
                    Navigator.of(context).pushNamed('/medical-plan-1');
                  },
                ),
                GestureDetector(
                  child: const CustomMessageListContainer(
                      Icons.info, "Neuer Medikamentenplan", "23.06.2023 14:43"),
                  onTap: () {
                    Navigator.of(context).pushNamed('/medical-plan-2');
                  },
                ),
              ],
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(1),
    );
  }
}
