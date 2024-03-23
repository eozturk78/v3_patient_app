import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../../shared/shared.dart';
import '../shared/shared.dart';

class RedirectionPage extends StatefulWidget {
  const RedirectionPage({super.key});
  @override
  State<RedirectionPage> createState() => _RedirectionPageState();
}

class _RedirectionPageState extends State<RedirectionPage> {
  final _formKey = GlobalKey<FormState>();
  Shared sh = new Shared();
  Apis apis = new Apis();
  bool remeberMeState = false;
  bool check1 = false;
  bool check2 = false;
  bool isSendEP = false;
  @override
  void initState() {
    // TODO: implement initState
    checkRemeberMe();
    super.initState();
  }

  checkRemeberMe() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo-imedcom.png",
              width: 160,
              height: 70,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              sh.getLanguageResource("welcome_imedcom"),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              sh.getLanguageResource("registration_desc"),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity, // <-- match_parent
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/login');
                },
                child: Text(
                  sh.getLanguageResource("register"),
                ),
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(), backgroundColor: mainButtonColor),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity, // <-- match_parent
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/registration-1');
                },
                child: Text(
                  sh.getLanguageResource("create_account"),
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
