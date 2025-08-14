import 'package:flutter/material.dart';
import 'package:v3_patient_app/colors/colors.dart';
import 'package:v3_patient_app/shared/toast.dart';
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
  Shared sh = Shared();
  @override
  void initState() {
    checkRememberMe();
    super.initState();
  }

  checkRememberMe() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingWithoutIcon(
          sh.getLanguageResource("registration_completed"), context),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                size: 120,
                color: Color.fromARGB(255, 0, 73, 3),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                  sh.getLanguageResource(
                      "patient_account_has_been_successfully"),
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity, // <-- match_parent
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: mainButtonColor),
                  child: Text(sh.getLanguageResource("log_in")),
                ),
              ),
            ]),
      ),
    );
  }
}
