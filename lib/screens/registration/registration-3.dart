import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/shared/toast.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../apis/apis.dart';
import '../../shared/shared.dart';
import '../shared/shared.dart';

class Registration3Page extends StatefulWidget {
  const Registration3Page({super.key});
  @override
  State<Registration3Page> createState() => _Registration3PageState();
}

class _Registration3PageState extends State<Registration3Page> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController birthDat8eController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  Shared sh = new Shared();
  bool isSendEP = false;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 365));
  String _selectedDateLabel = "Geburtsdatum auswählen";
  String _selectedGender = "Wähle Geschlecht";
  String _selectedHeight = "160 cm";
  String _selectedWeight = "70 kg";
  String _selectedSex = "";
  int _currentIntValue = 160;
  double _currentDoubleValue = 70;
  @override
  void initState() {
    // TODO: implement initState
    checkRemeberMe();
    super.initState();
  }

  checkRemeberMe() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingWithoutProfile('Registration 3!', context),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
            child: SizedBox(
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Personalisierung",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: mainButtonColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          'Lassen Sie uns iMedCom individuell an Sie anpassen.'),
                      SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Geburtsdatum",
                                style: labelText,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                _selectedDateLabel,
                                style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        const Color.fromARGB(255, 85, 85, 85)),
                              ),
                            ]),
                        onTap: () {
                          showGeneralDialog(
                              barrierLabel: "Label",
                              barrierColor: Colors.black.withOpacity(0.5),
                              transitionDuration: Duration(milliseconds: 200),
                              context: context,
                              barrierDismissible: true,
                              pageBuilder: (context, anim1, anim2) {
                                return Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 250,
                                    child: Scaffold(
                                      body: ScrollDatePicker(
                                        options: const DatePickerOptions(
                                          isLoop: false,
                                        ),
                                        scrollViewOptions:
                                            const DatePickerScrollViewOptions(),
                                        selectedDate: _selectedDate,
                                        locale: const Locale('de'),
                                        onDateTimeChanged: (DateTime value) {
                                          setState(() {
                                            _selectedDate = value;

                                            _selectedDateLabel = sh
                                                .formatDateTime(
                                                    _selectedDate.toString())
                                                .toString()
                                                .substring(0, 10);
                                          });
                                        },
                                      ),
                                    ),
                                    margin: EdgeInsets.only(
                                        top: 50,
                                        left: 10,
                                        right: 10,
                                        bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                );
                              },
                              transitionBuilder:
                                  (context, anim1, anim2, child) {
                                return SlideTransition(
                                  position: Tween(
                                          begin: Offset(0, 1),
                                          end: Offset(0, 0))
                                      .animate(anim1),
                                  child: child,
                                );
                              }).then((value) async {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setString(
                                'birthDate', value.toString().substring(0, 10));
                            _selectedDateLabel =
                                value.toString().substring(0, 10);
                            print(_selectedDateLabel);
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(color: const Color.fromARGB(255, 134, 134, 134)),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Geschlecht",
                                style: labelText,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                _selectedGender,
                                style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        const Color.fromARGB(255, 85, 85, 85)),
                              ),
                            ]),
                        onTap: () {
                          showGeneralDialog(
                              barrierLabel: "Label",
                              context: context,
                              barrierDismissible: true,
                              pageBuilder: (context, anim1, anim2) {
                                return Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 300,
                                    child: Scaffold(
                                        body: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _selectedGender = 'Unbekannt';
                                                _selectedSex = 'unknown';
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            child: Text(
                                              'Unbekannt',
                                              style: selectionLabel,
                                            )),
                                        Divider(
                                          color: const Color.fromARGB(
                                              255, 170, 170, 169),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _selectedGender = 'Weiblich';
                                                _selectedSex = 'female';
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            child: Text(
                                              'Weiblich',
                                              style: selectionLabel,
                                            )),
                                        Divider(
                                          color: const Color.fromARGB(
                                              255, 170, 170, 169),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _selectedGender = 'Männlich';
                                                _selectedSex = 'male';
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            child: Text(
                                              'Männlich',
                                              style: selectionLabel,
                                            )),
                                      ],
                                    )),
                                    margin: EdgeInsets.only(
                                        top: 50,
                                        left: 10,
                                        right: 10,
                                        bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                );
                              },
                              transitionBuilder:
                                  (context, anim1, anim2, child) {
                                return SlideTransition(
                                  position: Tween(
                                          begin: Offset(0, 1),
                                          end: Offset(0, 0))
                                      .animate(anim1),
                                  child: child,
                                );
                              });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(color: const Color.fromARGB(255, 134, 134, 134)),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Größe",
                                style: labelText,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                _selectedHeight,
                                style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        const Color.fromARGB(255, 85, 85, 85)),
                              ),
                            ]),
                        onTap: () {
                          showModalBottomSheet<int>(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setModalState) {
                                  return Container(
                                    height: 200,
                                    margin: const EdgeInsets.only(
                                        top: 50,
                                        left: 10,
                                        right: 10,
                                        bottom: 10),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0))),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              NumberPicker(
                                                value: _currentIntValue,
                                                minValue: 20,
                                                maxValue: 230,
                                                onChanged: (value) {
                                                  setModalState(() {
                                                    _currentIntValue = value;
                                                  });
                                                  setState(() {
                                                    _selectedHeight =
                                                        value.toString() +
                                                            " cm";
                                                  });
                                                },
                                              ),
                                              Text("cm"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              }).then(
                            (value) {
                              if (value != null) {
                                setState(() => _currentIntValue = value);
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(color: const Color.fromARGB(255, 134, 134, 134)),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Normalgewicht",
                                style: labelText,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                _selectedWeight,
                                style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        const Color.fromARGB(255, 85, 85, 85)),
                              ),
                            ]),
                        onTap: () {
                          showModalBottomSheet<double>(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setModalState) {
                                  return Container(
                                    height: 200,
                                    margin: const EdgeInsets.only(
                                        top: 50,
                                        left: 10,
                                        right: 10,
                                        bottom: 10),
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0))),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              DecimalNumberPicker(
                                                value: _currentDoubleValue,
                                                minValue: 20,
                                                maxValue: 230,
                                                decimalPlaces: 2,
                                                onChanged: (value) {
                                                  setModalState(() {
                                                    _currentDoubleValue = value;
                                                  });
                                                  setState(() {
                                                    _selectedWeight =
                                                        value.toString() +
                                                            " kg";
                                                  });
                                                },
                                              ),
                                              Text("KG"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              }).then(
                            (value) {
                              if (value != null) {
                                setState(() => _currentDoubleValue = value);
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(color: const Color.fromARGB(255, 134, 134, 134)),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          primary: mainButtonColor,
                        ),
                        onPressed: () async {
                          if (_selectedDate == 'Geburtsdatum auswählen' ||
                              _selectedGender == "Wähle Geschlecht") return;
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.setString("birthDate", _selectedDate.toString());
                          pref.setString("sex", _selectedSex.toString());
                          pref.setString(
                              "height",
                              _selectedHeight
                                  .toString()
                                  .substring(0, _selectedHeight.indexOf(" ")));
                          pref.setString(
                              "weight",
                              _selectedWeight
                                  .toString()
                                  .substring(0, _selectedWeight.indexOf(" ")));
                          // final isValid = _formKey.currentState?.validate();
                          Navigator.of(context).pushNamed('/registration-4');
                        },
                        child: Text("Weiter"),
                      )
                    ],
                  ),
                ))),
      ),
    );
  }
}
