import 'dart:async';

import 'package:flutter/material.dart';
import 'package:v3_patient_app/screens/shared/list-box.dart';
import 'package:v3_patient_app/screens/shared/shared.dart';

import '../../colors/colors.dart';
import '../shared/bottom-menu.dart';

class Questionnaire6Page extends StatefulWidget {
  const Questionnaire6Page({super.key});

  @override
  State<Questionnaire6Page> createState() => _Questionnaire6PageState();
}

class _Questionnaire6PageState extends State<Questionnaire6Page> {
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
            verticalDirection: VerticalDirection.down,
            children: [
              const Spacer(),
              Text(
                "Wie geht es Ihnen?",
                style: TextStyle(fontSize: 20),
              ),
              Column(
                children: [
                  RadioListTile(
                    value: 1,
                    groupValue: _groupValue,
                    onChanged: (newValue) =>
                        setState(() => _groupValue = newValue!),
                    title: Text("sehr gut"),
                  ),
                  RadioListTile(
                    value: 2,
                    groupValue: _groupValue,
                    onChanged: (newValue) =>
                        setState(() => _groupValue = newValue!),
                    title: Text("gut"),
                  ),
                  RadioListTile(
                    value: 3,
                    groupValue: _groupValue,
                    onChanged: (newValue) =>
                        setState(() => _groupValue = newValue!),
                    title: Text("mittelmäßig"),
                  ),
                  RadioListTile(
                    value: 4,
                    groupValue: _groupValue,
                    onChanged: (newValue) =>
                        setState(() => _groupValue = newValue!),
                    title: Text("schlecht"),
                  ),
                  RadioListTile(
                    value: 4,
                    groupValue: _groupValue,
                    onChanged: (newValue) =>
                        setState(() => _groupValue = newValue!),
                    title: Text("sehr schlecht"),
                  )
                ],
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
                            children: [Text("Überspringen"), Icon(Icons.close)],
                          )),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/questionnaire-7');
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
