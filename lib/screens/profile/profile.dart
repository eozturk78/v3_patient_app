import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      appBar: leadingSubpage('Mein Benutzerprofil', context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: const CustomProfileMenu(FontAwesomeIcons.addressCard, "Über mich"),
                  onTap: () {
                    Navigator.of(context).pushNamed("/about-me");
                  },
                ),
                const CustomProfileMenu(FontAwesomeIcons.hospitalUser, "Meine Diagnosen"),
                const CustomProfileMenu(
                    FontAwesomeIcons.bookMedical, "Meine medizinischen Kontakte"),
                const SizedBox(
                  height: 10,
                ),
                const Text("Mein Benutzerkonto",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: const CustomProfileMenu(FontAwesomeIcons.listCheck, "Einwilligungen"),
                  onTap: () {
                    Navigator.of(context).pushNamed("/edit-agreements");
                  },
                ),
                const CustomProfileMenu(
                    Icons.folder_copy_outlined, "Auszug meiner Daten"),
                const CustomProfileMenu(
                    FontAwesomeIcons.userPen, "Benutzerkonto bearbeiten"),
                const SizedBox(
                  height: 10,
                ),
                const Text("Rechtliches",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: const CustomProfileMenu(
                      FontAwesomeIcons.fileContract, "Nutzungsbedingungen"),
                  onTap: () {
                    Navigator.of(context).pushNamed("/terms-and-conditions");
                  },
                ),
                GestureDetector(
                  child: const CustomProfileMenu(FontAwesomeIcons.fileShield, "Datenschutzinformation"),
                  onTap: () {
                    Navigator.of(context).pushNamed("/privacy-policy");
                  },
                ),
                const CustomProfileMenu(FontAwesomeIcons.circleInfo, "Impressum "),
                GestureDetector(
                  child:
                      const CustomProfileMenu(FontAwesomeIcons.arrowRightFromBracket, "Abmelden"),
                  onTap: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.remove("token");
                    Navigator.of(context).pushNamed("/login");
                  },
                ),
                const Text("Version 1.2.4"),
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: const BottomNavigatorBar(0),
    );
  }
}
