import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../../model/message-notification.dart';
import '../../shared/shared.dart';
import '../../shared/toast.dart';
import '../shared/shared.dart';

class MedicineIntakeScreen extends StatefulWidget {
  @override
  _MedicineIntakeScreenState createState() => _MedicineIntakeScreenState();
}

class _MedicineIntakeScreenState extends State<MedicineIntakeScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _morningIntake = false;
  bool _noonIntake = false;
  bool _eveningIntake = false;
  bool _nightIntake = false;
  Shared sh = Shared();
  bool _isLoading = false;
  bool _isSaving = false;
  late Apis api;

  @override
  void initState() {
    super.initState();
    api = Apis(); // Initialize API class instance
    fetchMedicineIntake(); // Fetch medicine intake information when the screen is initialized
  }

  Future<void> saveMedicineIntake() async {
    try {
      setState(() {
        _isSaving = true;
      });

      Map<String, dynamic> _intakeData = {
        'datetaken': DateFormat('yyyy-MM-dd').format(_selectedDate).toString(),
        'morning': _morningIntake ? "1" : "0",
        'noon': _noonIntake ? "1" : "0",
        'afternoon': _eveningIntake ? "1" : "0",
        'evening': _nightIntake ? "1" : "0"
      };

      final data = await api
          .sendMedicineIntake(_intakeData)
          .onError((error, stackTrace) => sh.redirectPatient(error, context));

      if (data == "ok") {
        print('Saving medicine intake is OK');
      } else {
        //showToast(AppLocalizations.tr("Something went wrong"));
        print('Saving medicine intake is FAILED');
      }
    } catch (error) {
      print('Error fetching medicine intake: $error');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> fetchMedicineIntake() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final data = await api
          .fetchMedicineIntake(DateFormat('yyyy-MM-dd').format(_selectedDate))
          .onError((error, stackTrace) => sh.redirectPatient(error, context));

      if (data != null) {
        setState(() {
          _morningIntake = data['morning']?.isOdd ?? false;
          _noonIntake = data['noon']?.isOdd ?? false;
          _eveningIntake = data['afternoon']?.isOdd ?? false;
          _nightIntake = data['evening']?.isOdd ?? false;
          print('API call to get medicine intake made');
        });
      } else {
        print('Data is null');
      }
    } catch (error) {
      print('Error fetching medicine intake: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: leadingSubpage('Medicine Intake', context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Datum:",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 162, 28, 52)),
                    ),
                    Text(
                      DateFormat('dd.MM.yyyy').format(_selectedDate),
                      style: TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.calendar,
                        color: Color.fromARGB(255, 162, 28, 52),
                      ),
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: Color.fromARGB(255, 162, 28, 52),
                                hintColor: Color.fromARGB(255, 162, 28, 52),
                                colorScheme: ColorScheme.light(
                                    primary: Color.fromARGB(255, 162, 28, 52)),
                                buttonTheme: ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null && picked != _selectedDate) {
                          setState(() {
                            _selectedDate = picked;
                          });
                          fetchMedicineIntake();
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(child: Text("Bestätigung Medikamenteneinnahme")),
              SizedBox(height: 20),
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 5, 0, 18),
                  child: Column(
                    children: [
                      buildCheckbox('Einnahme morgens', _morningIntake, 10,
                          (bool? value) {
                        if (value != null) {
                          setState(() {
                            _morningIntake = value;
                          });
                          saveMedicineIntake();
                        }
                      }),
                      buildCheckbox('Einnahme mittags', _noonIntake, 20,
                          (bool? value) {
                        if (value != null) {
                          setState(() {
                            _noonIntake = value;
                          });
                          saveMedicineIntake();
                        }
                      }),
                      buildCheckbox('Einnahme abends', _eveningIntake, 30,
                          (bool? value) {
                        if (value != null) {
                          setState(() {
                            _eveningIntake = value;
                          });
                          saveMedicineIntake();
                        }
                      }),
                      buildCheckbox('Einnahme nachts', _nightIntake, 40,
                          (bool? value) {
                        if (value != null) {
                          setState(() {
                            _nightIntake = value;
                          });
                          saveMedicineIntake();
                        }
                      })
                    ],
                  ),
                ),
              if (_isSaving) Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCheckbox(String label, bool value, int typeOfValue,
      ValueChanged<bool?> onChanged) {
    return GestureDetector(
      onTap: () {
        onChanged(!value); // Toggle the value when the label is tapped
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              width: 24, // Adjust the size of the circular checkbox
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: value
                    ? Color.fromARGB(255, 162, 28, 52)
                    : Colors.transparent,
                border: Border.all(
                  color: Color.fromARGB(255, 162, 28, 52),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: value
                    ? Icon(
                        Icons.check,
                        size: 18,
                        color: Colors.white,
                      )
                    : Container(),
              ),
            ),
            SizedBox(
                width:
                    8), // Add some spacing between the checkbox and the label
            Text(
              label,
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            TextButton(
                onPressed: () {
                  Apis apis = Apis();

                  apis.getPatientNotificationList().then(
                    (resp) => {
                      setState(() async {
                        var notificationList = (resp as List)
                            .map((e) => MessageNotification.fromJson(e))
                            .toList();
                        var messageList = notificationList
                            .where((element) => element.notificationtype == 20);

                        var defaultMsg =
                            "Hallo, ich habe eine Frage zu den morgendlichen Medikamenten";
                        if (typeOfValue == 20)
                          defaultMsg =
                              "Hallo, ich habe eine Frage zu den Mittagsmedikamenten";
                        else if (typeOfValue == 30)
                          defaultMsg =
                              "Hallo, ich habe eine Frage an die Abendmedizin";
                        else if (typeOfValue == 40)
                          defaultMsg =
                              "Hallo, ich habe eine Frage zu Nachtmedikamenten";
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.setString("defaultMsg", defaultMsg);
                        if (messageList.length == 1) {
                          var element = messageList.first;
                          pref.setString(
                              "organization", element.organization ?? "");
                          pref.setString("thread", element.thread ?? "");

                          Navigator.pushNamed(context, '/chat');
                        } else {
                          Navigator.pushNamed(context, '/messaegs');
                        }
                      }),
                    },
                    onError: (err) {
                      sh.redirectPatient(err, context);
                      setState(
                        () {
                          //isStarted = false;
                        },
                      );
                    },
                  );
                },
                child: Icon(
                  Icons.messenger_sharp,
                  color: mainButtonColor,
                ))
          ],
        ),
      ),
    );
  }
}
