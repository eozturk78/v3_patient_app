import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:patient_app/apis/apis.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:patient_app/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/bottom-menu.dart';

class QuickAccessPage extends StatefulWidget {
  const QuickAccessPage({super.key});

  @override
  State<QuickAccessPage> createState() => _QuickAccessPageState();
}

class _QuickAccessPageState extends State<QuickAccessPage> {
  Shared sh = Shared();
  @override
  void initState() {
    super.initState();
    renewToken();
  }

  Apis apis = Apis();
  renewToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    apis.patientrenewtoken().then((value) async {
      tokenTimeOutSecondDB = value['tokenTimeOutSecond'];
      tokenTimeOutSecond = value['tokenTimeOutSecond'];
      popUpAppearSecond = value['popUpAppearSecond'];
      pref.setString("token", value['token']);
    }, onError: (err) => sh.redirectPatient(err, null));
    sh.openPopUp(context, 'extract-data');
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalObjectKey<ExpandableFabState>(context);
    return Scaffold(
      appBar: leading(sh.getLanguageResource("quick_access"), context),
      body: SafeArea(
          // Wrap your body with SafeArea
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [],
          ),
        ),
      )),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: key,
        distance: 60.0,
        type: ExpandableFabType.up,
        child: const Icon(Icons.add),
        overlayStyle: ExpandableFabOverlayStyle(
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
            onPressed: () => {},
            icon: new Icon(Icons.dock_outlined),
            label: Text(sh.getLanguageResource("video_consultation")),
          ),
          FloatingActionButton.extended(
            onPressed: () => {},
            icon: new Icon(Icons.dock_outlined),
            label: Text(sh.getLanguageResource("medical_plan")),
          ),
          FloatingActionButton.extended(
            onPressed: () => {},
            icon: new Icon(Icons.dock_outlined),
            label: Text(sh.getLanguageResource("blood_pressure_measurement")),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 4),
    );
  }
}
