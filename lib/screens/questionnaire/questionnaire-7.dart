import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';

import '../../colors/colors.dart';
import '../shared/bottom-menu.dart';

class Questionnaire7Page extends StatefulWidget {
  const Questionnaire7Page({super.key});

  @override
  State<Questionnaire7Page> createState() => _Questionnaire7PageState();
}

class _Questionnaire7PageState extends State<Questionnaire7Page> {
  int _groupValue = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('HaNeu Fragebögen!', context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Center(
                  child: Text(
                "Haben Sie Sport getrieben?",
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
                            Navigator.of(context).pushNamed('/questionnaire-9');
                          },
                          style: ElevatedButton.styleFrom(
                            primary: mainButtonColor,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text("Nein"), Icon(Icons.close)],
                          )),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/questionnaire-8');
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text("Ja"), Icon(Icons.check)],
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigatorBar(0),
    );
  }
}
