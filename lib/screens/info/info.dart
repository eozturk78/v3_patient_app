import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../shared/bottom-menu.dart';
import '../shared/sub-total.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingWithoutBack('Infothek', context),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: ResponsiveGridRow(
                    children: [
                      ResponsiveGridCol(
                        lg: 2,
                        xs: 6,
                        md: 4,
                        child: GestureDetector(
                          child: CustomSubTotal(
                              SvgPicture.asset(
                                  'assets/images/menu-icons/bibliothek-main.svg'),
                              "Bibliothek",
                              null,
                              null,
                              10),
                          onTap: () {
                            Navigator.of(context).pushNamed('/libraries');
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
                                  'assets/images/menu-icons/dokumente-main.svg'),
                              "Meine Dokumente",
                              null,
                              null,
                              10),
                          onTap: () {
                            Navigator.of(context).pushNamed('/documents');
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
                                  'assets/images/menu-icons/aufklarung-main.svg'),
                              "Aufklärung",
                              null,
                              null,
                              10),
                          onTap: () {
                            Navigator.of(context).pushNamed('/enlightenment');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 4),
    );
  }
}
