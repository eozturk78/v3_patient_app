import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/apis/apis.dart';
import 'package:patient_app/model/diagnose.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../colors/colors.dart';
import '../../shared/shared.dart';
import '../shared/bottom-menu.dart';
import '../shared/diagnose-box.dart';
import '../shared/sub-total.dart';

class ExtractDataPage extends StatefulWidget {
  const ExtractDataPage({super.key});

  @override
  State<ExtractDataPage> createState() => _ExtractDataPageState();
}

class _ExtractDataPageState extends State<ExtractDataPage> {
  Apis apis = Apis();
  Shared sh = Shared();
  List<PatientDiagnose> diagnoseList = [];
  bool isStarted = true;
  @override
  void initState() {
    super.initState();
    onGetRecipes();
  }

  onGetRecipes() {
    apis.getPatientDiagnoses().then(
      (value) {
        setState(() {
          isStarted = false;
          print(value);
          diagnoseList =
              (value as List).map((e) => PatientDiagnose.fromJson(e)).toList();
        });
      },
      onError: (err) {
        sh.redirectPatient(err, context);
        setState(
          () {
            isStarted = false;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leading('Auszug meiner Daten', context),
      body: SafeArea(
          // Wrap your body with SafeArea
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Bitte verwenden Sie die Schaltfläche unten, um Daten zu extrahieren. Die Vorbereitung der gesamten Daten kann einige Zeit in Anspruch nehmen",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      )), // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButton: ElevatedButton(
          onPressed: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            await launch(
                '${apis.apiPublic}/extractdata?token=${pref.getString('token')}');
          },
          child: Text("Daten extrahieren")),
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 3),
    );
  }
}
