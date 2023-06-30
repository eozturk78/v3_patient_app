import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';

import '../shared/bottom-menu.dart';

class QuickAccessPage extends StatefulWidget {
  const QuickAccessPage({super.key});

  @override
  State<QuickAccessPage> createState() => _QuickAccessPageState();
}

class _QuickAccessPageState extends State<QuickAccessPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalObjectKey<ExpandableFabState>(context);
    return Scaffold(
      appBar: leading('Schnellzugriff!', context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [],
          ),
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: key,
        // duration: const Duration(seconds: 1),
        distance: 60.0,
        type: ExpandableFabType.up,
        // fanAngle: 70,
        child: const Icon(Icons.add),
        // foregroundColor: Colors.amber,
        // backgroundColor: Colors.green,
        // closeButtonStyle: const ExpandableFabCloseButtonStyle(
        //   child: Icon(Icons.abc),
        //   foregroundColor: Colors.deepOrangeAccent,
        //   backgroundColor: Colors.lightGreen,
        // ),
        // expandedFabShape: const CircleBorder(),
        // collapsedFabShape: const CircleBorder(),
        overlayStyle: ExpandableFabOverlayStyle(
          // color: Colors.black.withOpacity(0.5),
          blur: 3,
        ),
        onOpen: () {
          debugPrint('onOpen');
        },
        afterOpen: () {
          debugPrint('afterOpen');
        },
        onClose: () {
          debugPrint('onClose');
        },
        afterClose: () {
          debugPrint('afterClose');
        },
        children: [
          FloatingActionButton.extended(
            onPressed: () => {
              // フローティングアクションボタンを押された時の処理.
            },
            icon: new Icon(Icons.dock_outlined),
            label: Text("Videosprechstunde"),
          ),
          FloatingActionButton.extended(
            onPressed: () => {
              // フローティングアクションボタンを押された時の処理.
            },
            icon: new Icon(Icons.dock_outlined),
            label: Text("Medikamentenplan"),
          ),
          FloatingActionButton.extended(
            onPressed: () => {
              // フローティングアクションボタンを押された時の処理.
            },
            icon: new Icon(Icons.dock_outlined),
            label: Text("Blutdruckmessung"),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(4),
    );
  }
}
