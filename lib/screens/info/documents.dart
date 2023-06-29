import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../shared/bottom-menu.dart';
import '../shared/document-box.dart';
import '../shared/library-box.dart';
import '../shared/medication-plan-box.dart';
import '../shared/profile-menu.dart';

class DocumentListPage extends StatefulWidget {
  const DocumentListPage({super.key});

  @override
  State<DocumentListPage> createState() => _DocumentListPageState();
}

class _DocumentListPageState extends State<DocumentListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Meine Dokumente!', context),
      body: Center(
          child: Padding(
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  verticalDirection: VerticalDirection.down,
                  children: [
                    Text(
                        "Hier können Sie Ihre ärztliche Dokumente ablegen und verwalten."),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/document-details',
                              arguments: 'Medikamentenpläne');
                        },
                        child: CustomDocumentBox(
                            Icons.medication_outlined, "Medikamentenpläne")),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/document-details',
                              arguments: 'Fragebögen');
                        },
                        child: CustomDocumentBox(
                            Icons.medication_outlined, "Fragebögen")),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('/document-details', arguments: 'EKG');
                        },
                        child: CustomDocumentBox(
                            Icons.medication_outlined, "EKG")),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/document-details',
                              arguments: 'Anamnese');
                        },
                        child: CustomDocumentBox(
                            Icons.medication_outlined, "Anamnese")),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/document-details',
                              arguments: 'Laborberichte');
                        },
                        child: CustomDocumentBox(
                            Icons.medication_outlined, "Laborberichte")),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/document-details',
                              arguments: 'Bildgebung');
                        },
                        child: CustomDocumentBox(
                            Icons.medication_outlined, "Bildgebung")),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/document-details',
                              arguments: 'Laborberichte');
                        },
                        child: CustomDocumentBox(
                            Icons.medication_outlined, "Laborberichte")),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/document-details',
                              arguments: 'Krankenhaus - und Arztbriefe');
                        },
                        child: CustomDocumentBox(Icons.medication_outlined,
                            "Krankenhaus - und Arztbriefe")),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/document-details',
                              arguments: 'Therapien');
                        },
                        child: CustomDocumentBox(
                            Icons.medication_outlined, "Therapien")),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/document-details',
                              arguments: 'Vollmachten und Verfügungen');
                        },
                        child: CustomDocumentBox(Icons.medication_outlined,
                            "Vollmachten und Verfügungen")),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/document-details',
                              arguments: 'Sonstige Dokumente');
                        },
                        child: CustomDocumentBox(
                            Icons.medication_outlined, "Sonstige Dokumente")),
                  ],
                ),
              ))), // This trailing comma makes auto-formatting nicer for build methods.
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
