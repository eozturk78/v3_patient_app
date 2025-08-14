import 'dart:async';

import 'package:flutter/material.dart';
import 'package:v3_patient_app/screens/shared/list-box.dart';
import 'package:v3_patient_app/screens/shared/shared.dart';

import '../../colors/colors.dart';
import '../shared/bottom-menu.dart';

class Questionnaire8Page extends StatefulWidget {
  const Questionnaire8Page({super.key});

  @override
  State<Questionnaire8Page> createState() => _Questionnaire8PageState();
}

class _Questionnaire8PageState extends State<Questionnaire8Page> {
  int _groupValue = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('HaNeu Fragebögen', context),
      body: SafeArea(
          // Wrap your body with SafeArea
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              TextFormField(
                obscureText: false,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText:
                      'Wenn ja, wie lange und welche Sportart? (in Minuten)',
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainButtonColor,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Überspringen"),
                                Icon(Icons.close)
                              ],
                            ))),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/questionnaire-9');
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text("Weiter"), Icon(Icons.check)],
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )),
      ////bottomNavigationBar: BottomNavigatorBar(selectedIndex: 0),
    );
  }
}
