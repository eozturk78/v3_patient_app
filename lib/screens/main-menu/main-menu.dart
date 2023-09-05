import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../main.dart';
import '../communication/calendar.dart';
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
  int _selectedIndex = 0;

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
      _selectedIndex = 0;
    });
    //print('User returned to MainMenuPage');
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
      appBar: leadingWithoutBack('Dashboard', context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hallo ${title}!",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(244, 115, 123, 126),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: const Color.fromARGB(255, 244, 246, 246),
                            hintText: 'Suchen',
                            hintStyle: TextStyle(
                                fontSize: 16.0,
                                color: Color.fromARGB(255, 69, 81, 84)),
                            prefixIcon: Icon(Icons.search_sharp),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                child: const CustomSubTotal(
                                    FontAwesomeIcons.user,
                                    "Profil",
                                    null,
                                    null,
                                    10),
                                onTap: () {
                                  Navigator.of(context).pushNamed('/profile');
                                },
                              ),
                              const Spacer(),
                              GestureDetector(
                                child: const CustomSubTotal(
                                    FontAwesomeIcons.fileMedical,
                                    "Daten",
                                    null,
                                    null,
                                    20),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed('/main-sub-menu');
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                child: const CustomSubTotal(
                                    FontAwesomeIcons.kitMedical,
                                    "Medikation",
                                    null,
                                    null,
                                    10),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed('/medication');
                                },
                              ),
                              const Spacer(),
                              GestureDetector(
                                child: const CustomSubTotal(
                                    FontAwesomeIcons.message,
                                    "Nachrichten",
                                    null,
                                    null,
                                    20),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed('/communication');
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                child: const CustomSubTotal(
                                  Icons.timer_sharp,
                                  "Erinnerungen",
                                  null,
                                  null,
                                  10,
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => CalendarScreen()),
                                  );
                                },
                              ),
                              const Spacer(),
                              GestureDetector(
                                child: const CustomSubTotal(Icons.info_outline,
                                    "Infothek", null, null, 10),
                                onTap: () {
                                  Navigator.of(context).pushNamed('/info');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: _selectedIndex),
    );
  }
}
