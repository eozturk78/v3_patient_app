import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/shared/toast.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  int _currentIntValue = 10;

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
                                  "Select date",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: const Color.fromARGB(
                                          255, 85, 85, 85)),
                                ),
                              ]),
                          onTap: () {
                            showGeneralDialog(
                                barrierLabel: "Label",
                                barrierDismissible: true,
                                barrierColor: Colors.black.withOpacity(0.5),
                                transitionDuration: Duration(milliseconds: 200),
                                context: context,
                                pageBuilder: (context, anim1, anim2) {
                                  return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 250,
                                      child: Scaffold(
                                        body: ScrollDatePicker(
                                          options: DatePickerOptions(
                                            isLoop: false,
                                          ),
                                          scrollViewOptions:
                                              DatePickerScrollViewOptions(),
                                          selectedDate: _selectedDate,
                                          locale: Locale('de'),
                                          onDateTimeChanged: (DateTime value) {
                                            setState(() {
                                              _selectedDate = value;
                                              print(_selectedDate);
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
                                });
                          }),
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
                                "Select gender",
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
                                        Text(
                                          'Keine Angabe',
                                          style: selectionLabel,
                                        ),
                                        Divider(
                                          color: const Color.fromARGB(
                                              255, 170, 170, 169),
                                        ),
                                        Text(
                                          'Mannlich',
                                          style: selectionLabel,
                                        ),
                                        Divider(
                                          color: const Color.fromARGB(
                                              255, 170, 170, 169),
                                        ),
                                        Text(
                                          'Weiblich',
                                          style: selectionLabel,
                                        ),
                                        Divider(
                                          color: const Color.fromARGB(
                                              255, 170, 170, 169),
                                        ),
                                        Text(
                                          'Divers',
                                          style: selectionLabel,
                                        ),
                                        Divider(
                                          color: const Color.fromARGB(
                                              255, 170, 170, 169),
                                        ),
                                        Text(
                                          'Unbekannt',
                                          style: selectionLabel,
                                        ),
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
                                "Select gender",
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
                                      body: NumberPicker(
                                        value: _currentIntValue,
                                        minValue: 0,
                                        maxValue: 100,
                                        step: 1,
                                        haptics: true,
                                        onChanged: (value) => setState(() {
                                          _currentIntValue = value;
                                          print(value);
                                        }),
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
                                "Normalgewicht",
                                style: labelText,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Select Normalgewicht",
                                style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        const Color.fromARGB(255, 85, 85, 85)),
                              ),
                            ]),
                        onTap: () {},
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
                          // final isValid = _formKey.currentState?.validate();
                          //if (!isValid! || isSendEP) return;
                          Navigator.of(context).pushNamed('/registration-3');
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
