import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuickMenuPage extends StatelessWidget {
  final Map<String, Widget Function(BuildContext)> routes;

  QuickMenuPage(this.routes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quick Menu'),
      ),
      body: ListView(
        children: routes.keys.map((routeName) {
          return ListTile(
            title: Text(routeName),
            onTap: () {
              Navigator.pop(context); // Close the Quick Menu
              Navigator.pushNamed(context, routeName); // Navigate to selected route
            },
          );
        }).toList(),
      ),
    );
  }
}