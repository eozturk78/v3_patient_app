import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../shared/bottom-menu.dart';
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
      _notificationsEnabled = prefs.getBool('medication_notifications_enabled') ?? true;
    });
  }

  // Save user preference for notification enable/disable to SharedPreferences
  Future<void> _saveMedicationNotificationPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('medication_notifications_enabled', value);
    await apis.setPatientMedicationReminderPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Einstellungen', context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Medikamentenerinnerungen',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Aktivieren Medikamentenerinnerungen'),
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                    _saveMedicationNotificationPreference(value);
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      //bottomNavigationBar: BottomNavigatorBar(0),
    );
  }
}



  // Generate unique notification id for the medication plan
  //final int notificationId = UniqueKey().hashCode;
