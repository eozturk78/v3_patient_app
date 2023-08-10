import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main-menu/route_util.dart';

import 'custom_menu.dart';

class CustomizedMenuPage extends StatefulWidget {
  @override
  _CustomizedMenuPageState createState() => _CustomizedMenuPageState();
}

class _CustomizedMenuPageState extends State<CustomizedMenuPage> {
  List<Map<String, dynamic>> _customizedMenuItems = [];
  List<CustomMenuItem> _menuItems = []; // Store all menu items

  @override
  void initState() {
    super.initState();
    _loadCustomizedMenuItems();
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

  Future<void> _loadCustomizedMenuItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customizedItemsJson = prefs.getString('selectedMenuItems');

    if (customizedItemsJson != null || customizedItemsJson != '') {
      List<dynamic> decodedList = jsonDecode(customizedItemsJson!);

      if (decodedList is List<dynamic>) {
        setState(() {
          _customizedMenuItems = decodedList.cast<Map<String, dynamic>>();
        });
      }
    }
  }

  void _navigateToPage(String routeName) {
    // Implement the navigation logic based on the route name
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> selectedMenuItems = _customizedMenuItems
        .where((item) => item['isSelected'] == true)
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text('Schnellzugriffsmenü'),
      ),
      body: selectedMenuItems.isEmpty
          ? Center(child: Text('No customized menu items available.'))
          : Padding(padding: EdgeInsets.only(top: 15.0), child: ListView.builder(
        itemCount: selectedMenuItems.length,
        itemBuilder: (context, index) {
          String displayName = selectedMenuItems[index]['displayName'];
          String routeName = selectedMenuItems[index]['routeName'];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Theme.of(context).errorColor),foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white)),
              onPressed: () => _navigateToPage(routeName),
              child: Text(displayName),
            ),
          );
        },
      ),),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[800],
        foregroundColor: Colors.white,
        onPressed: _navigateToCustomMenu,
        child: const Icon(Icons.edit),
      ),
    );
  }
  void _navigateToCustomMenu() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CustomMenuPage(menuItems: _menuItems),
    ));
    _loadCustomizedMenuItems(); // Reload menu items when returning from customization page
  }

}
