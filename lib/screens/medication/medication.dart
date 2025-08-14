import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:v3_patient_app/apis/apis.dart';
import 'package:v3_patient_app/screens/shared/list-box.dart';
import 'package:v3_patient_app/screens/shared/shared.dart';
import 'package:v3_patient_app/shared/shared.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/bottom-menu.dart';
import '../shared/sub-total.dart';

class MedicationPage extends StatefulWidget {
  const MedicationPage({super.key});

  @override
  State<MedicationPage> createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  Shared sh = Shared();
  @override
  void initState() {
    super.initState();
    sh.openPopUp(context, 'medication');
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
    return Scaffold(
      appBar: leadingSubpage(sh.getLanguageResource("medication"), context),
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
                                  'assets/images/menu-icons/medikamentenplan-main.svg'),
                              sh.getLanguageResource("medical_plan"),
                              null,
                              null,
                              10,
                              false),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/medication-plan-list');
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
                                  'assets/images/menu-icons/rezept-main.svg'),
                              sh.getLanguageResource("recipe"),
                              null,
                              null,
                              20,
                              false),
                          onTap: () {
                            Navigator.of(context).pushNamed('/recipes');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
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
                                  'assets/images/menu-icons/medikamentenplan-main.svg'),
                              sh.getLanguageResource(
                                  "interactive_medical_plan"),
                              null,
                              null,
                              10,
                              false),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/interactive-medication-plan');
                          },
                        ),
                      ),
                    ),
                    ResponsiveGridCol(
                      lg: 2,
                      xs: 6,
                      md: 4,
                      child: Padding(
                        padding: EdgeInsets.only(left: 3, right: 3),
                        child: GestureDetector(
                          child: CustomSubTotal(
                              SvgPicture.asset(
                                  'assets/images/menu-icons/medikamentenplan-main.svg'),
                              sh.getLanguageResource("medication_intake"),
                              null,
                              null,
                              10,
                              false),
                          onTap: () {
                            Navigator.of(context).pushNamed('/medicine-intake');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      ////bottomNavigationBar: BottomNavigatorBar(selectedIndex: 2),
    );
  }
}
