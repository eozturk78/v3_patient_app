import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../colors/colors.dart';
import '../../model/scale-size.dart';
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
                                textScaleFactor:
                                    ScaleSize.textScaleFactor(context),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
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
                                  textScaleFactor:
                                      ScaleSize.textScaleFactor(context),
                                  style: TextStyle(color: mainButtonColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed("/settings");
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
                                  textScaleFactor:
                                      ScaleSize.textScaleFactor(context),
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
              height: 20,
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
                    textScaleFactor: ScaleSize.textScaleFactor(context),
                  ),
                  Divider(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/about-me");
                    },
                    style: profileBtnStyle,
                    child: Row(
                      children: [
                        Text(
                          "Über mich",
                          style: profileMenuItemColor,
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: mainButtonColor,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/diagnoses");
                    },
                    style: profileBtnStyle,
                    child: Row(
                      children: [
                        Text(
                          "Meine Diagnosen",
                          style: profileMenuItemColor,
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: mainButtonColor,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/patient-contacts-list");
                    },
                    style: profileBtnStyle,
                    child: Row(
                      children: [
                        Text(
                          "Meine medizinischen Kontakte",
                          style: profileMenuItemColor,
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: mainButtonColor,
                          size: 20,
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
                    textScaleFactor: ScaleSize.textScaleFactor(context),
                  ),
                  Divider(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/edit-agreements");
                    },
                    style: profileBtnStyle,
                    child: Row(
                      children: [
                        Text(
                          "Einwilligungen",
                          style: profileMenuItemColor,
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: mainButtonColor,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/extract-data");
                    },
                    style: profileBtnStyle,
                    child: Row(
                      children: [
                        Text(
                          "Auszug meiner Daten",
                          style: profileMenuItemColor,
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: mainButtonColor,
                          size: 20,
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
                    textScaleFactor: ScaleSize.textScaleFactor(context),
                  ),
                  Divider(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/terms-and-conditions");
                    },
                    style: profileBtnStyle,
                    child: Row(
                      children: [
                        Text(
                          "Nutzungsbedingungen",
                          style: profileMenuItemColor,
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: mainButtonColor,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/privacy-policy");
                    },
                    style: profileBtnStyle,
                    child: Row(
                      children: [
                        Text(
                          "Datenschutzinformation",
                          style: profileMenuItemColor,
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: mainButtonColor,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/impresum");
                    },
                    style: profileBtnStyle,
                    child: Row(
                      children: [
                        Text(
                          "Impressum",
                          style: profileMenuItemColor,
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: mainButtonColor,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  TextButton(
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.remove("token");
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          "/login", ModalRoute.withName('/login'));
                    },
                    style: profileBtnStyle,
                    child: Row(
                      children: [
                        Text(
                          "Abmelden",
                          style: profileMenuItemColor,
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: mainButtonColor,
                          size: 20,
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
              child: Text(
                "Version 1.2.4",
              ),
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
