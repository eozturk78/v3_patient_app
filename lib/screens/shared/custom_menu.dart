import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedMenuItems = routeDisplayNames.entries.map((entry) {
      return CustomMenuItem(
        entry.key, // Use the display name as the route name
        entry.value, // Use the route name from the map
        false, // Default isSelected value
        0, // Use the existing order
      );
    }).toList();

    _loadSelectedMenuItems(); // Load selected menu items on initialization
  }



  void _loadSelectedMenuItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String selectedMenuItemsDataString = prefs.getString('selectedMenuItems') ?? '';

    if (selectedMenuItemsDataString.isEmpty || selectedMenuItemsDataString == '') {
      setState(() {
        _selectedMenuItems = routeDisplayNames.entries.map((entry) {
          return CustomMenuItem(
            entry.key, // Use the display name as the route name
            entry.value, // Use the route name from the map
            false, // Default isSelected value
            _selectedMenuItems.length, // Use the existing order
          );
        }).toList();
      });
    } else {
      // Decode and update the selected menu items
      List<Map<String, dynamic>> selectedMenuItemsData = List<Map<String, dynamic>>.from(
        jsonDecode(selectedMenuItemsDataString),
      );

      setState(() {
        _selectedMenuItems = selectedMenuItemsData.map((itemData) {
          return CustomMenuItem(
            itemData['routeName'],
            itemData['displayName'],
            itemData['isSelected'],
            itemData['order'],
          );
        }).toList();
      });
    }
  }


  void _saveSelectedMenuItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> selectedMenuItemsData = _selectedMenuItems.map((
        item) {
      return {
        'routeName': item.routeName,
        'displayName': item.displayName,
        'isSelected': item.isSelected,
        'order': item.order,
      };
    }).toList();
    prefs.setString('selectedMenuItems', jsonEncode(selectedMenuItemsData));
    Navigator.pop(context); // Close the customization page after saving
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
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedMenuItems == null) {
      return CircularProgressIndicator(); // Show a loading indicator
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text('Schnellzugriff festlegen'),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.red[800],),
            onPressed: _saveSelectedMenuItems,
          ),
        ],
      ),
      body: _selectedMenuItems.isEmpty
          ? _buildDefaultMenuItems()
          : ReorderableListView(
        onReorder: _onReorder,
        children: _selectedMenuItems.map((item) {
          return ListTile(
            key: Key(item.routeName),
          title: Row(
          children: [
          const Icon(Icons.drag_handle), // Add this line for the drag handle icon
          const SizedBox(width: 16), // Add spacing between the icon and title
          Text(item.displayName),
          ]),
            trailing: Switch(
              value: item.isSelected,
              onChanged: (value) {
                setState(() {
                  item.isSelected = value;
                });
              },
            ),
          );
        }).toList(),
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
              });
            },
          ),
        );
      },
    );
  }
}