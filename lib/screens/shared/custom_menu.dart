import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:patient_app/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../colors/colors.dart';
import '../main-menu/route_util.dart';

class CustomMenuItem {
  final String routeName;
  final String displayName;
  bool isSelected;
  int order; // Add this field

  CustomMenuItem(this.routeName, this.displayName, this.isSelected, this.order);
}

class CustomMenuPage extends StatefulWidget {
  final List<CustomMenuItem> menuItems;

  CustomMenuPage({required this.menuItems});

  @override
  _CustomMenuPageState createState() => _CustomMenuPageState();
}

class _CustomMenuPageState extends State<CustomMenuPage> {
  late List<CustomMenuItem> _selectedMenuItems;
  Shared sh = Shared();
  @override
  void initState() {
    super.initState();
    _selectedMenuItems = routeDisplayNames.entries.map((entry) {
      return CustomMenuItem(
        entry.key, // Use the display name as the route name
        entry.value.displayName!, // Use the route name from the map
        false, // Default isSelected value
        0, // Use the existing order
      );
    }).toList();

    _loadSelectedMenuItems(); // Load selected menu items on initialization
  }

  void _loadSelectedMenuItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String selectedMenuItemsDataString =
        prefs.getString('selectedMenuItems') ?? '';

    if (selectedMenuItemsDataString.isEmpty ||
        selectedMenuItemsDataString == '') {
      setState(() {
        _selectedMenuItems = routeDisplayNames.entries.map((entry) {
          return CustomMenuItem(
            entry.key, // Use the display name as the route name
            entry.value.displayName!, // Use the route name from the map
            defaultMenuList.contains(entry.key), // Default isSelected value
            _selectedMenuItems.length, // Use the existing order
          );
        }).toList();
      });
    } else {
      // Decode and update the selected menu items
      List<Map<String, dynamic>> selectedMenuItemsData =
          List<Map<String, dynamic>>.from(
        jsonDecode(selectedMenuItemsDataString),
      );
      print(selectedMenuItemsData);

      setState(() {
        _selectedMenuItems = routeDisplayNames.entries.map((entry) {
          print(entry.key);
          return CustomMenuItem(
            entry.key, // Use the display name as the route name
            entry.value.displayName!, // Use the route name from the map
            !selectedMenuItemsData
                .where((element) =>
                    element['routeName'].toString().contains(entry.key) &&
                    element['isSelected'] == true)
                .isEmpty,
            _selectedMenuItems.length,
          );
        }).toList();
      });
    }
  }

  void _saveSelectedMenuItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('selectedMenuItems');
    List<Map<String, dynamic>> selectedMenuItemsData =
        _selectedMenuItems.map((item) {
      return {
        'routeName': item.routeName,
        'displayName': item.displayName,
        'isSelected': item.isSelected,
        'order': item.order,
      };
    }).toList();
    prefs.setString('selectedMenuItems', jsonEncode(selectedMenuItemsData));
    //Navigator.pop(context); // Close the customization page after saving
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _selectedMenuItems.removeAt(oldIndex);
      _selectedMenuItems.insert(newIndex, item);

      // Update the order for all items after reordering
      for (int i = 0; i < _selectedMenuItems.length; i++) {
        _selectedMenuItems[i].order = i;
      }

      _saveSelectedMenuItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedMenuItems == null) {
      return CircularProgressIndicator(); // Show a loading indicator
    }

    return Scaffold(
      appBar: leadingSubpage(sh.getLanguageResource("settings"), context),
      body: _selectedMenuItems.isEmpty
          ? _buildDefaultMenuItems()
          : Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed("/profile");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: mainButtonColor),
                                  ),
                                  height: 35,
                                  child: Center(
                                    child: Text(
                                      sh.getLanguageResource("users"),
                                      style: TextStyle(color: mainButtonColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(2),
                                          bottomLeft: Radius.circular(2)),
                                      color: mainButtonColor),
                                  height: 35,
                                  child: Center(
                                    child: Text(
                                      sh.getLanguageResource("dashboard"),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed("/settings");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: mainButtonColor),
                                  ),
                                  height: 35,
                                  child: Center(
                                    child: Text(
                                      sh.getLanguageResource("notifications"),
                                      style: TextStyle(color: mainButtonColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: const Color.fromARGB(255, 244, 246, 246),
                            hintText: sh.getLanguageResource("search"),
                            hintStyle: TextStyle(
                                fontSize: 16.0,
                                color: Color.fromARGB(255, 69, 81, 84)),
                            prefixIcon: Icon(Icons.search_sharp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    width: double.infinity,
                    padding: EdgeInsets.all(2),
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: ReorderableListView(
                      header: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding:
                                  EdgeInsets.only(top: 20, bottom: 5, left: 15),
                              child: Text(
                                sh.getLanguageResource("dashboard_fields"),
                                style: TextStyle(
                                    color: Color.fromARGB(255, 150, 159, 162)),
                                textAlign: TextAlign.left,
                              )),
                          Divider(
                            thickness: 1,
                          ),
                        ],
                      ),
                      onReorder: _onReorder,
                      children: _selectedMenuItems.map(
                        (item) {
                          /*return Container(
                            key: UniqueKey(),
                            decoration: BoxDecoration(
                              border: Border(
                                      bottom: BorderSide(
                                              color: Colors.white54, // Adjust the color as needed
                                              width: 0.5, // Adjust the width as needed
                                              ),
                                      ),
                          ),
                          child:*/
                          return ListTile(
                            key: Key(item.routeName),
                            title: Row(children: [
                              const Icon(Icons
                                  .drag_handle), // Add this line for the drag handle icon
                              const SizedBox(
                                  width:
                                      12), // Add spacing between the icon and title
                              Expanded(
                                  child: Text(
                                sh.getLanguageResource(item.displayName),
                                style: TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 1,
                              )),
                            ]),
                            trailing: Transform.scale(
                              scale: 1,
                              child: CupertinoSwitch(
                                activeColor: mainButtonColor,
                                value: item.isSelected,
                                onChanged: (value) {
                                  setState(() {
                                    item.isSelected = value;
                                    _saveSelectedMenuItems();
                                  });
                                },
                              ),
                            ),
                            //)
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildDefaultMenuItems() {
    return ListView.builder(
      itemCount: _selectedMenuItems.length,
      itemBuilder: (context, index) {
        final item = _selectedMenuItems[index];
        return ListTile(
          key: Key(item.routeName),
          title: Text(item.displayName),
          trailing: Switch(
            value: item.isSelected,
            onChanged: (value) {
              setState(() {
                item.isSelected = value;
                _saveSelectedMenuItems();
              });
            },
          ),
        );
      },
    );
  }
}
