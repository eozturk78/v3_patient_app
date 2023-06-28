import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/message-list-container.dart';
import 'package:patient_app/screens/shared/shared.dart';

import '../shared/bottom-menu.dart';
import '../shared/message-text-bubble.dart';

class MedicalPlan2Page extends StatefulWidget {
  const MedicalPlan2Page({super.key});

  @override
  State<MedicalPlan2Page> createState() => _MedicalPlan2PageState();
}

class _MedicalPlan2PageState extends State<MedicalPlan2Page> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Nachrichten!', context),
      body: const Padding(
        padding: EdgeInsets.all(15),
        child: CustomMessageTextBubble(
            "assets/images/message-2.png",
            "Für Sie wurde ein neuer Medikamentenplan erstellt. Diesen können Sie über den nachfolgenden Link abrufen:https://imc-app.de/pdf/1687519862205",
            '23.06.2023 14:43',
            10,
            'David Brockmann'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(1),
    );
  }
}
