import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../../shared/shared.dart';
import '../shared/shared.dart';

class NotificationHistoryPage extends StatefulWidget {
  const NotificationHistoryPage({super.key});
  @override
  State<NotificationHistoryPage> createState() => _NotificationHistoryPage();
}

class _NotificationHistoryPage extends State<NotificationHistoryPage> {
  Shared sh = Shared();
  Apis apis = Apis();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
              child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [Text("Notication History")],
            ),
          )),
        ),
      ),
    );
  }
}
