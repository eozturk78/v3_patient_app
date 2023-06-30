import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';

import '../../colors/colors.dart';
import '../shared/bottom-menu.dart';

class Questionnaire2Page extends StatefulWidget {
  const Questionnaire2Page({super.key});

  @override
  State<Questionnaire2Page> createState() => _Questionnaire2PageState();
}

class _Questionnaire2PageState extends State<Questionnaire2Page> {
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
            verticalDirection: VerticalDirection.down,
            children: [
              const Spacer(),
              Text(
                "Blutdruck",
                style: TextStyle(fontSize: 20),
              ),
              TextFormField(
                obscureText: false,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Systolisher Blutdruck',
                ),
              ),
              TextFormField(
                obscureText: false,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Diastolisher Blutdruck',
                ),
              ),
              TextFormField(
                obscureText: false,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Puls',
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
                            primary: mainButtonColor,
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
                            Navigator.of(context).pushNamed('/questionnaire-3');
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
      ),
      bottomNavigationBar: BottomNavigatorBar(0),
    );
  }
}
