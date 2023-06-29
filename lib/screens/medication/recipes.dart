import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';

import '../shared/bottom-menu.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leading('Rezept!', context),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Krankenkasse bzw, Kostentrager",
              style: TextStyle(fontWeight: FontWeight.bold, color: iconColor),
            ),
            Text(
              "Musterkasse",
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Name, Vername dess Versicherten",
              style: TextStyle(fontWeight: FontWeight.bold, color: iconColor),
            ),
            Text(
              "Max Mustermann,  Mustergasse 1 12345 Musterstadt",
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "geb. am",
              style: TextStyle(fontWeight: FontWeight.bold, color: iconColor),
            ),
            Text(
              "10.10.2000",
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Kassen-Nr",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: iconColor),
                ),
                Text(
                  "Versicherten-Nr",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: iconColor),
                ),
                Text(
                  "Status",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: iconColor),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "123456",
                ),
                Text(
                  "1928376",
                ),
                Text(
                  "1001 1",
                ),
              ],
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(2),
    );
  }
}
