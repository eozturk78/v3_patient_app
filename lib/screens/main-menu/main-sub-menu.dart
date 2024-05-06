import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:patient_app/apis/apis.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:patient_app/shared/shared.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/bottom-menu.dart';
import '../shared/sub-total.dart';

class MainSubMenuPage extends StatefulWidget {
  const MainSubMenuPage({super.key});

  @override
  State<MainSubMenuPage> createState() => _MainSubMenuPageState();
}

class _MainSubMenuPageState extends State<MainSubMenuPage> {
  String title = "";
  Shared sh = Shared();
  @override
  void initState() {
    super.initState();
    getPatientInfo();
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

  getPatientInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      title = pref.getString("patientTitle") ?? "";
      sh.openPopUp(context, 'main-sub-menu');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage(sh.getLanguageResource("data"), context),
      body: SafeArea(
          // Wrap your body with SafeArea
          child: Center(
              child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: [
            ResponsiveGridRow(
              children: [
                ResponsiveGridCol(
                  lg: 2,
                  xs: 6,
                  md: 4,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: GestureDetector(
                      child: CustomSubTotal(
                          SvgPicture.asset(
                              'assets/images/menu-icons/tagliche-main.svg'),
                          sh.getLanguageResource("daily_measurements"),
                          null,
                          null,
                          10),
                      onTap: () {
                        Navigator.of(context).pushNamed('/questionnaire-group');
                      },
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 2,
                  xs: 6,
                  md: 4,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: GestureDetector(
                      child: CustomSubTotal(
                          SvgPicture.asset(
                              'assets/images/menu-icons/graphische-main.svg'),
                          sh.getLanguageResource("graph_representation"),
                          null,
                          null,
                          20),
                      onTap: () {
                        Navigator.of(context).pushNamed('/home');
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ))), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 1),
    );
  }
}
