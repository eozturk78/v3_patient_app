import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:url_launcher/url_launcher.dart';

import '../shared/bottom-menu.dart';
import '../shared/library-box.dart';
import '../shared/medication-plan-box.dart';

class LibraryListPage extends StatefulWidget {
  const LibraryListPage({super.key});

  @override
  State<LibraryListPage> createState() => _LibraryListPageState();
}

class _LibraryListPageState extends State<LibraryListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Bibliothek!', context),
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: [
            GestureDetector(
              onTap: () async {
                await launch("https://imc-app.de/patient-file/16");
              },
              child: CustomLibraryBox("Was muss ich zur Herzschwäche wissen ?"),
            ),
            GestureDetector(
              onTap: () async {
                await launch("https://imc-app.de/patient-file/17");
              },
              child:
                  CustomLibraryBox("Welche Formen der Herzschwäche gibt es ?"),
            ),
            GestureDetector(
              onTap: () async {
                await launch("https://imc-app.de/patient-file/18");
              },
              child:
                  CustomLibraryBox("Helfen Sportprogramme, fit zu bleiben ?"),
            ),
            GestureDetector(
              onTap: () async {
                await launch("https://imc-app.de/patient-file/19");
              },
              child: CustomLibraryBox(
                  "Ist ein intensives Telemonitoring bei fortgeschrittener Herzschwäche sinnvoll ?"),
            ),
          ],
        ),
      )), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(3),
    );
  }
}
