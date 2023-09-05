import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../colors/colors.dart';
import '../shared/bottom-menu.dart';
import '../shared/custom_menu.dart';
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
      appBar: leadingSubpage('Einstellungen', context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(2),
                                    bottomLeft: Radius.circular(2)),
                                color: mainButtonColor),
                            height: 35,
                            child: Center(
                              child: Text(
                                "Benutzer",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) =>
                                    CustomMenuPage(menuItems: []),
                              ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(color: mainButtonColor),
                                    top: BorderSide(color: mainButtonColor)),
                              ),
                              height: 35,
                              child: Center(
                                child: Text(
                                  "Dashboard",
                                  style: TextStyle(color: mainButtonColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed("/settings");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: mainButtonColor),
                              ),
                              height: 35,
                              child: Center(
                                child: Text(
                                  "Erinnerungen",
                                  style: TextStyle(color: mainButtonColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: const Color.fromARGB(255, 244, 246, 246),
                        hintText: 'Search',
                        hintStyle: TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 69, 81, 84)),
                        prefixIcon: Icon(Icons.search_sharp),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              width: double.infinity,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BENUTZERPROFIL",
                    style: TextStyle(color: Color.fromARGB(255, 150, 159, 162)),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed("/about-me");
                    },
                    child: Row(
                      children: [
                        Text(
                          "Über mich",
                          style: profileMenuItemColor,
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: mainButtonColor,
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed("/diagnoses");
                    },
                    child: Row(
                      children: [
                        Text(
                          "Meine Diagnosen",
                          style: profileMenuItemColor,
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: mainButtonColor,
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed("/patient-contacts-list");
                    },
                    child: Row(
                      children: [
                        Text(
                          "Meine medizinischen Kontakte",
                          style: profileMenuItemColor,
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: mainButtonColor,
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "BENUTZERKONTO",
                    style: TextStyle(color: Color.fromARGB(255, 150, 159, 162)),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed("/edit-agreements");
                    },
                    child: Row(
                      children: [
                        Text(
                          "Einwilligungen",
                          style: profileMenuItemColor,
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: mainButtonColor,
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed("/extract-data");
                    },
                    child: Row(
                      children: [
                        Text(
                          "Auszug meiner Daten",
                          style: profileMenuItemColor,
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: mainButtonColor,
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "RECHTLICHES",
                    style: TextStyle(color: Color.fromARGB(255, 150, 159, 162)),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed("/terms-and-conditions");
                    },
                    child: Row(
                      children: [
                        Text(
                          "Nutzungsbedingungen",
                          style: profileMenuItemColor,
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: mainButtonColor,
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed("/privacy-policy");
                    },
                    child: Row(
                      children: [
                        Text(
                          "Datenschutzinformation",
                          style: profileMenuItemColor,
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: mainButtonColor,
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed("/impresum");
                    },
                    child: Row(
                      children: [
                        Text(
                          "Impressum",
                          style: profileMenuItemColor,
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: mainButtonColor,
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.remove("token");
                      Navigator.of(context).pushNamed("/login");
                    },
                    child: Row(
                      children: [
                        Text(
                          "Abmelden",
                          style: profileMenuItemColor,
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: mainButtonColor,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            const Center(
              child: Text("Version 1.2.4"),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigatorBar(
        selectedIndex: 1,
      ),
    );
  }
}
