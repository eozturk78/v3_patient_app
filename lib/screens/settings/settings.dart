import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../shared/bottom-menu.dart';
import '../shared/custom_menu.dart';
import '../shared/profile-menu.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

bool _notificationsEnabled = true; // Default value

class _SettingsPageState extends State<SettingsPage> {
  Apis apis = Apis();

  @override
  void initState() {
    super.initState();
    // Load user preference for notification enable/disable on app startup
    _loadNotificationPreference();
  }

  // Load user preference for notification enable/disable from SharedPreferences
  Future<void> _loadNotificationPreference() async {
    await apis.getPatientMedicationReminderPreference();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled =
          prefs.getString('medication_notifications_enabled') == "true"
              ? true
              : false;
    });
  }

  // Save user preference for notification enable/disable to SharedPreferences
  Future<void> _saveMedicationNotificationPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(value);
    prefs.setString('medication_notifications_enabled', value.toString());
    await apis.setPatientMedicationReminderPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Einstellungen', context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed("/profile");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: mainButtonColor),
                              ),
                              height: 35,
                              child: Center(
                                child: Text(
                                  "Benutzer",
                                  style: TextStyle(color: mainButtonColor),
                                ),
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
                                  style: TextStyle(color: mainButtonColor),
                                ),
                              ),
                            ),
                          ),
                        ),
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
                                "Erinnerungen",
                                style: TextStyle(color: Colors.white),
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
                        hintText: 'Suchen',
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
                  const Text(
                    'MEDIKAMENTENERINNERUNGEN',
                    style: TextStyle(color: Color.fromARGB(255, 150, 159, 162)),
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text(
                        "Aktivieren",
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      Transform.scale(
                        scale: 1,
                        child: CupertinoSwitch(
                          activeColor: mainButtonColor,
                          value: _notificationsEnabled,
                          onChanged: (value) {
                            setState(() {
                              _notificationsEnabled = value;
                            });
                            _saveMedicationNotificationPreference(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigatorBar(
        selectedIndex: 0,
      ),
    );
  }
}



  // Generate unique notification id for the medication plan
  //final int notificationId = UniqueKey().hashCode;
