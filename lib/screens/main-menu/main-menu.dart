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
  List<MenuSet> _menuItems = []; // Store all menu items

  @override
  void initState() {
    super.initState();
    getPatientInfo();

    _loadMenuItems(); // Load menu items from shared preferences
  }

  void _loadMenuItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? selectedRouteNamesJson = prefs.getString('selectedMenuItems');
    print("stored data");
    print(selectedRouteNamesJson);

    if (selectedRouteNamesJson != null && selectedRouteNamesJson != '') {
      List<dynamic> selectedRouteNames = jsonDecode(selectedRouteNamesJson!);

      selectedRouteNames.forEach((element) {
        if (element['isSelected'] == true) {
          var p = routeDisplayNames.entries
              .where((x) => x.key == element['routeName'])
              .first;
          p.value.routerName = element['routeName'];
          _menuItems.add(p.value);
        }
      });
      /*setState(() {
        _menuItems = allRoutes.entries.map((entry) {
          return CustomMenuItem(
            entry.key,
            entry.key,
            selectedRouteNames.contains(entry.key), // Check if item is selected

            0, // Add a default order value
          );
        }).toList();
      });*/
    } else {
      defaultMenuList.forEach((element) {
        var p = routeDisplayNames.entries.where((x) => x.key == element).first;
        p.value.routerName = element;
        _menuItems.add(p.value);
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
                        height: 12,
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
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
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
                          GridView.count(
                              crossAxisCount: 2,
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              reverse: false,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              children:
                                  List.generate(_menuItems.length, (index) {
                                return GestureDetector(
                                  child: CustomSubTotal(
                                      _menuItems[index].icon,
                                      _menuItems[index].displayName!,
                                      null,
                                      null,
                                      10),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        _menuItems[index].routerName!);
                                  },
                                );
                              })),
                          /**/
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
