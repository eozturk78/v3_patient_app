import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:patient_app/screens/shared/shared.dart';
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
  @override
  void initState() {
    super.initState();
    getPatientInfo();
  }

  getPatientInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      title = pref.getString("patientTitle") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Daten', context),
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
                  child: GestureDetector(
                    child: CustomSubTotal(
                        SvgPicture.asset(
                            'assets/images/menu-icons/tagliche-main.svg'),
                        "Tägliche Messungen",
                        null,
                        null,
                        10),
                    onTap: () {
                      Navigator.of(context).pushNamed('/questionnaire-group');
                    },
                  ),
                ),
                ResponsiveGridCol(
                  lg: 2,
                  xs: 6,
                  md: 4,
                  child: GestureDetector(
                    child: CustomSubTotal(
                        SvgPicture.asset(
                            'assets/images/menu-icons/graphische-main.svg'),
                        "Grafische Darstellungen",
                        null,
                        null,
                        20),
                    onTap: () {
                      Navigator.of(context).pushNamed('/home');
                    },
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
