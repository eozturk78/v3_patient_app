import 'dart:async';

import 'package:flutter/material.dart';
import 'package:v3_patient_app/apis/apis.dart';
import 'package:v3_patient_app/model/diagnose.dart';
import 'package:v3_patient_app/screens/shared/list-box.dart';
import 'package:v3_patient_app/screens/shared/shared.dart';
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
    renewToken();
  }

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
    return Scaffold(
      appBar: leading(sh.getLanguageResource("extract_my_data"), context),
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
                sh.getLanguageResource("extract_my_data_desc"),
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
          child: Text(
            sh.getLanguageResource("extract_data"),
          )),
      ////bottomNavigationBar: BottomNavigatorBar(selectedIndex: 3),
    );
  }
}
