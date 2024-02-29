import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../shared/bottom-menu.dart';
import '../shared/sub-total.dart';

class MedicationPage extends StatefulWidget {
  const MedicationPage({super.key});

  @override
  State<MedicationPage> createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Medikation', context),
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
                                'assets/images/menu-icons/medikamentenplan-main.svg'),
                            "Medikamentenplan",
                            null,
                            null,
                            10),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('/medication-plan-list');
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
                                'assets/images/menu-icons/rezept-main.svg'),
                            "Rezept",
                            null,
                            null,
                            20),
                        onTap: () {
                          Navigator.of(context).pushNamed('/recipes');
                        },
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
                      child: GestureDetector(
                        child: CustomSubTotal(
                            SvgPicture.asset(
                                'assets/images/menu-icons/medikamentenplan-main.svg'),
                            "interaktiver Medikamentenplan",
                            null,
                            null,
                            10),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('/interactive-medication-plan');
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
                                'assets/images/menu-icons/medikamentenplan-main.svg'),
                            "Medikamenteneinahme",
                            null,
                            null,
                            10),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('/medicine-intake');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 2),
    );
  }
}
