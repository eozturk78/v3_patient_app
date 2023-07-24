import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/bottom-menu.dart';
import '../shared/profile-menu.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Mein Benutzerprofil!', context),
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                child: CustomProfileMenu(Icons.heat_pump_sharp, "Über mich"),
                onTap: () {
                  Navigator.of(context).pushNamed("/about-me");
                },
              ),
              CustomProfileMenu(Icons.add_box_outlined, "Meine Diagnosen"),
              CustomProfileMenu(
                  Icons.medical_information, "Meine medizinischen Kontakte"),
              SizedBox(
                height: 10,
              ),
              Text("Mein Benutzerkonto",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 20,
              ),
              CustomProfileMenu(Icons.folder_copy_outlined, "Einwilligungen"),
              CustomProfileMenu(
                  Icons.folder_copy_outlined, "Auszug meiner Daten"),
              CustomProfileMenu(
                  Icons.folder_copy_outlined, "Benutzerkonto bearbeiten"),
              SizedBox(
                height: 10,
              ),
              Text("Rechtliches",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 20,
              ),
              CustomProfileMenu(
                  Icons.summarize_outlined, "Nutzungsbedingungen"),
              CustomProfileMenu(Icons.summarize_outlined, "Datenschutz"),
              CustomProfileMenu(Icons.summarize_outlined, "Impressum "),
              GestureDetector(
                child: CustomProfileMenu(Icons.summarize_outlined, "Abmelden"),
                onTap: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.remove("token");
                  Navigator.of(context).pushNamed("/login");
                },
              ),
              Text("Version 1.2.1"),
            ],
          ),
        ),
      )), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(0),
    );
  }
}
