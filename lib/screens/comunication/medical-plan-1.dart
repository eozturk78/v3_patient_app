import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/message-list-container.dart';
import 'package:patient_app/screens/shared/shared.dart';

import '../shared/bottom-menu.dart';
import '../shared/message-text-bubble.dart';

class MedicalPlan1Page extends StatefulWidget {
  const MedicalPlan1Page({super.key});

  @override
  State<MedicalPlan1Page> createState() => _MedicalPlan1PageState();
}

class _MedicalPlan1PageState extends State<MedicalPlan1Page> {
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
          "assets/images/message-1.png",
          "Für Sie wurde ein neuer Medikamentenplan erstellt. Diesen können Sie über den nachfolgenden Link abrufen:https://imc-app.de/pdf/1687516298951",
          '23.06.2023 13:31',
          10,
          'David Brockmann',
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(1),
    );
  }
}
