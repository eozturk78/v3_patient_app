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
  const MainMenuPage({Key? key}) : super(key: key);

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
    // We can execute logic here when the user returns to this page
    setState(() {
      _loadMenuItems();
      _selectedIndex = 0;
    });
    //print('User returned to MainMenuPage');
  }

  Apis apis = Apis();
  Shared sh = Shared();
  Key _refreshKey = UniqueKey();

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
    setState(() {
      if (selectedRouteNamesJson != null && selectedRouteNamesJson != '') {
        List<dynamic> selectedRouteNames = jsonDecode(selectedRouteNamesJson!);

        _menuItems.clear();
        selectedRouteNames.forEach((element) {
          if (element['isSelected'] == true) {
            if (routeDisplayNames.entries
                    .where((x) => x.key == element['routeName'])
                    .length >
                0) {
              var p = routeDisplayNames.entries
                  .where((x) => x.key == element['routeName'])
                  .first;
              p.value.routerName = element['routeName'];
              _menuItems.add(p.value);
            }
          }
        });
      } else {
        _menuItems.clear();
        defaultMenuList.forEach((element) {
          print(element);
          var p =
              routeDisplayNames.entries.where((x) => x.key == element).first;
          p.value.routerName = element;
          _menuItems.add(p.value);
        });
      }
      _refreshKey = UniqueKey();
      //print(_refreshKey);
    });
  }

  getPatientInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      //pref.setString('selectedMenuItems', ''); // To reset quick menu items
      title = pref.getString('patientTitle')!;
      pref.setString("patientTitle", title);
    });
    await apis.patientInfo().then((value) {
      //print(value);
      setState(() {
        pref.setString("patientGroups", jsonEncode(value['patientGroups']));
      });
    }, onError: (err) {
      sh.redirectPatient(err, context);
      setState(() {});
    });
  }

  Widget buildCustomizedMenuItemButtons(BuildContext context) {
    return GridView.builder(
      key: _refreshKey,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 15,
      ),
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: _menuItems.length,
      itemBuilder: (context, index) {
        final menuItem = _menuItems[index];
        return GestureDetector(
          child: CustomSubTotal(
            key: UniqueKey(), // UniqueKey for CustomSubTotal
            menuItem.icon,
            menuItem.displayName!,
            null,
            null,
            10,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(menuItem.routerName!);
          },
        );
      },
    );
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
                        padding: EdgeInsets.only(left: 0, right: 0),
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
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Builder(
                              key: _refreshKey,
                              builder: (BuildContext context) {
                                // This Builder will rebuild the UI when _menuItems change
                                return buildCustomizedMenuItemButtons(context);
                                /**/
                              })
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
