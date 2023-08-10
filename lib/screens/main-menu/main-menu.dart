import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../shared/bottom-menu.dart';
import '../shared/custom_menu.dart';
import '../../apis/apis.dart';
import '../../shared/shared.dart';
import '../shared/shared.dart';
import '../shared/sub-total.dart';
import 'route_util.dart';
import '../shared/customized_menu.dart'; // Import the customized_menu.dart file

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({Key? key});

  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  Apis apis = Apis();
  Shared sh = Shared();

  String title = "";
  List<CustomMenuItem> _menuItems = []; // Store all menu items

  @override
  void initState() {
    super.initState();
    getPatientInfo();

    _loadMenuItems(); // Load menu items from shared preferences
  }

  void _loadMenuItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? selectedRouteNamesJson = prefs.getString('selectedMenuItems');

    if (selectedRouteNamesJson != null || selectedRouteNamesJson!='') {
      List<dynamic> selectedRouteNames = jsonDecode(selectedRouteNamesJson!);

      setState(() {
        _menuItems = allRoutes.entries.map((entry) {
          return CustomMenuItem(
            entry.key,
            entry.key,
            selectedRouteNames.contains(entry.key), // Check if item is selected
            0, // Add a default order value
          );
        }).toList();
      });
    }
  }


  getPatientInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      //pref.setString('selectedMenuItems', ''); // To reset quick menu items
      title = pref.getString('patientTitle')!;
      pref.setString("patientTitle", title);
    });
    await apis.patientInfo().then((value) {
      print(value);
      setState(() {
        pref.setString("patientGroups", jsonEncode(value['patientGroups']));
      });
    }, onError: (err) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingWithoutBack('Hallo $title!', context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: [
              Row(
                children: [
                  GestureDetector(
                    child: const CustomSubTotal(FontAwesomeIcons.user,
                        "Mein \nBenutzerprofil", null, null, 10),
                    onTap: () {
                      Navigator.of(context).pushNamed('/profile');
                    },
                  ),
                  const Spacer(),
                  GestureDetector(
                    child: const CustomSubTotal(FontAwesomeIcons.fileMedical,
                        "Datenmanagement\n", null, null, 20),
                    onTap: () {
                      Navigator.of(context).pushNamed('/main-sub-menu');
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    child: const CustomSubTotal(
                        FontAwesomeIcons.kitMedical,
                        "Medikation & \nRezepte",
                        null,
                        null,
                        10),
                    onTap: () {
                      Navigator.of(context).pushNamed('/medication');
                    },
                  ),
                  const Spacer(),
                  GestureDetector(
                    child: const CustomSubTotal(FontAwesomeIcons.message,
                        "Kommunikation\n", null, null, 20),
                    onTap: () {
                      Navigator.of(context).pushNamed('/communication');
                    },
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: const CustomSubTotal(Icons.info_outline,
                        "Dokumente & \nInformationen", null, null, 10),
                    onTap: () {
                      Navigator.of(context).pushNamed('/info');
                    },
                  ),
                  const Spacer(),
                  GestureDetector(
                    child: const CustomSubTotal(
                      Icons.view_cozy_outlined,
                      "Schnellzugriffsmenü\n",
                      null,
                      null,
                      10,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CustomizedMenuPage()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigatorBar(0),
    );

  }


}
