import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../../shared/shared.dart';
import '../shared/shared.dart';

class RegistrationCompletedPage extends StatefulWidget {
  const RegistrationCompletedPage({super.key});
  @override
  State<RegistrationCompletedPage> createState() =>
      _RegistrationCompletedPageState();
}

class _RegistrationCompletedPageState extends State<RegistrationCompletedPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    checkRemeberMe();
    super.initState();
  }

  checkRemeberMe() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingWithoutIcon('Registrierung vervollständigt', context),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                size: 120,
                color: const Color.fromARGB(255, 0, 73, 3),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Das Patientenkonto wurde erfolgreich erstellt",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity, // <-- match_parent
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                  child: Text("ANMELDEN"),
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(), backgroundColor: mainButtonColor),
                ),
              ),
            ]),
      ),
    );
  }
}
