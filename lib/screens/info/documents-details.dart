import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../shared/bottom-menu.dart';
import '../shared/document-box.dart';
import '../shared/library-box.dart';
import '../shared/medication-plan-box.dart';
import '../shared/profile-menu.dart';

class DocumentDetailsPage extends StatefulWidget {
  const DocumentDetailsPage({super.key});

  @override
  State<DocumentDetailsPage> createState() => _DocumentDetailsPageState();
}

class _DocumentDetailsPageState extends State<DocumentDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalObjectKey<ExpandableFabState>(context);
    String title = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: leadingSubpage(title, context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.pages_outlined,
              size: 100,
              color: iconColor,
            ),
            Container(
              width: 300,
              child: Text(
                "Es wurden noch keine Dokumente abgelegt. ",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: iconColor),
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: key,
        // duration: const Duration(seconds: 1),
        distance: 60.0,
        type: ExpandableFabType.up,
        // fanAngle: 70,
        child: const Icon(Icons.add),
        // foregroundColor: Colors.amber,
        // backgroundColor: Colors.green,
        // closeButtonStyle: const ExpandableFabCloseButtonStyle(
        //   child: Icon(Icons.abc),
        //   foregroundColor: Colors.deepOrangeAccent,
        //   backgroundColor: Colors.lightGreen,
        // ),
        // expandedFabShape: const CircleBorder(),
        // collapsedFabShape: const CircleBorder(),
        overlayStyle: ExpandableFabOverlayStyle(
          // color: Colors.black.withOpacity(0.5),
          blur: 3,
        ),
        onOpen: () {
          debugPrint('onOpen');
        },
        afterOpen: () {
          debugPrint('afterOpen');
        },
        onClose: () {
          debugPrint('onClose');
        },
        afterClose: () {
          debugPrint('afterClose');
        },
        children: [
          FloatingActionButton.extended(
            onPressed: () => {
              // フローティングアクションボタンを押された時の処理.
            },
            icon: new Icon(Icons.image),
            label: Text("Fotogalerie"),
          ),
          FloatingActionButton.extended(
            onPressed: () => {
              // フローティングアクションボタンを押された時の処理.
            },
            icon: new Icon(Icons.image),
            label: Text("Foto aufnehmen"),
          ),
          FloatingActionButton.extended(
            onPressed: () => {
              // フローティングアクションボタンを押された時の処理.
            },
            icon: new Icon(Icons.image),
            label: Text("Datei auswählen"),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigatorBar(3),
    );
  }
}
