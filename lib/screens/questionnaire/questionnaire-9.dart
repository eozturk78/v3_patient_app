import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';

import '../../colors/colors.dart';
import '../shared/bottom-menu.dart';

class Questionnaire9Page extends StatefulWidget {
  const Questionnaire9Page({super.key});

  @override
  State<Questionnaire9Page> createState() => _Questionnaire9PageState();
}

class _Questionnaire9PageState extends State<Questionnaire9Page> {
  int _groupValue = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('HaNeu Fragebögen', context),
      body: SafeArea( // Wrap your body with SafeArea
      child:Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Center(
                  child: Text(
                "Möchten Sie alle Fragebögen versenden??",
                style: TextStyle(fontSize: 20),
              )),
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
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/home');
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text("Bestätigen"), Icon(Icons.check)],
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
