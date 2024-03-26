import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:patient_app/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../colors/colors.dart';
import '../../model/scale-size.dart';
import '../shared/bottom-menu.dart';
import '../shared/custom_menu.dart';
import '../shared/profile-menu.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Shared sh = Shared();
  @override
  void initState() {
    super.initState();
    getInfoVersion();
  }

  String? version;
  getInfoVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
      print(version);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage(sh.getLanguageResource("settings"), context),
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
                                sh.getLanguageResource("users"),
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
                                  sh.getLanguageResource("dashboard"),
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
                                  sh.getLanguageResource("notifications"),
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
                        hintText: sh.getLanguageResource("search"),
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
                    sh.getLanguageResource("user_profile"),
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
                          sh.getLanguageResource("about_me"),
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
                          sh.getLanguageResource("my_diagnoses"),
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
                          sh.getLanguageResource("my_medical_contacts"),
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
                    sh.getLanguageResource("user_account"),
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
                          sh.getLanguageResource("consents"),
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
                          sh.getLanguageResource("extract_my_data"),
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
                    sh.getLanguageResource("legal"),
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
                          sh.getLanguageResource("term_of_use"),
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
                          sh.getLanguageResource("data_protection_information"),
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
                          sh.getLanguageResource("imprint"),
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
                      Navigator.of(context).pushNamed("/language");
                    },
                    style: profileBtnStyle,
                    child: Row(
                      children: [
                        Text(
                          sh.getLanguageResource("language"),
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
                      //pref.remove("userName");
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          "/login", ModalRoute.withName('/login'));
                    },
                    style: profileBtnStyle,
                    child: Row(
                      children: [
                        Text(
                          sh.getLanguageResource("log_out"),
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
            Center(
              child: version != null
                  ? Text(
                      "${sh.getLanguageResource("version")} ${version}",
                    )
                  : Text(""),
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
