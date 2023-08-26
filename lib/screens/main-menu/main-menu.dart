import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../main.dart';
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

class _MainMenuPageState extends State<MainMenuPage> with RouteAware {
  int _selectedIndex = -1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentModalRoute = ModalRoute.of(context);
    if (currentModalRoute != null) {
      // Check if currentModalRoute is not null
      routeObserver.subscribe(this, currentModalRoute);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // Implement the RouteAware methods
  @override
  void didPopNext() {
    // This method is called when a route is popped (subpage is closed)
    // You can execute logic here when the user returns to this page
    setState(() {
      _selectedIndex = -1;
    });
    print('User returned to MainMenuPage');
  }

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

    if (selectedRouteNamesJson != null || selectedRouteNamesJson != '') {
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
      sh.redirectPatient(err, context);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingWithoutBack('Hallo $title!', context),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo-imedcom.png",
                    width: 200,
                    height: 100,
                  ),
                ],
              ),
              const Spacer(),
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
                        "Datenmanagement", null, null, 20),
                    onTap: () {
                      Navigator.of(context).pushNamed('/main-sub-menu');
                    },
                  ),
                  const Spacer(),
                  GestureDetector(
                    child: const CustomSubTotal(FontAwesomeIcons.kitMedical,
                        "Medikation & \nRezepte", null, null, 10),
                    onTap: () {
                      Navigator.of(context).pushNamed('/medication');
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    child: const CustomSubTotal(FontAwesomeIcons.message,
                        "Kommunikation", null, null, 20),
                    onTap: () {
                      Navigator.of(context).pushNamed('/communication');
                    },
                  ),
                  const Spacer(),
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
                      "Schnellzugriffsmenü",
                      null,
                      null,
                      10,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => CustomizedMenuPage()),
                      );
                    },
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      )),
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: _selectedIndex),
    );
  }
}
