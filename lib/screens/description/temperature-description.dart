import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:patient_app/shared/shared.dart';
import 'package:photo_view/photo_view.dart';

import '../shared/bottom-menu.dart';

class TemperatureDescriptionPage extends StatefulWidget {
  const TemperatureDescriptionPage({super.key});

  @override
  State<TemperatureDescriptionPage> createState() =>
      _TemperatureDescriptionPageState();
}

class _TemperatureDescriptionPageState
    extends State<TemperatureDescriptionPage> {
  Shared sh = Shared();

  @override
  void initState() {
    super.initState();
    sh.openPopUp(context, 'temperature-description');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingDescSubpage('Vitalwerte', context),
      body: SafeArea(
          // Wrap your body with SafeArea
          child: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                sh.getLanguageResource("vital_signs_categorisation"),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                sh.getLanguageResource("vital_signs_desc"),
                //"Wir möchten Ihnen wichtige Informationen über die Einstufungen von Vitalwerten bereitstellen. Diese helfen Ihnen bei der Interpretation Ihrer gemessenen Werte und unterstützen Sie ein besseres Verständnis für Ihren Gesundheitszustand zu entwickeln. Weiterhin spielen die tabellarisch aufgeführten Grenzwerte  eine wesentliche Rolle in den Standardeinstellungen des Algorithmus unserer Gesundheit-App. Betreuende Ärzte haben zudem die Möglichkeit, die Grenzwerte individuell auf einzelne Patienten anzupassen.",
              ),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/blutdruck-description');
                        },
                        style: descriptionNotStyle,
                        child: Text(
                          sh.getLanguageResource("blood_pressure"),
                        )),
                    const SizedBox(
                      width: 3,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/weight-description');
                        },
                        style: descriptionNotStyle,
                        child: Text(
                          sh.getLanguageResource("weight"),
                        )),
                    const SizedBox(
                      width: 3,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/saturation-description');
                        },
                        style: descriptionNotStyle,
                        child: Text(
                          //'Sauerstoffsättigung',
                          sh.getLanguageResource("oxygen_saturation"),
                        )),
                    const SizedBox(
                      width: 3,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/pulse-description');
                        },
                        style: descriptionNotStyle,
                        child: Text(
                          //  'Herzfrequenz',
                          sh.getLanguageResource("pulse"),
                        )),
                    SizedBox(
                      width: 3,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/temperature-description');
                        },
                        child: Text(
                          //'Temperatur',
                          sh.getLanguageResource("tempreture"),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(sh.getLanguageResource("tempreture_desc_1"),
                        //"Temperatur - Bedeutung, Messung und Auswirkungen",
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("tempreture_desc_2"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("tempreture_desc_3"),
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("tempreture_desc_4"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("tempreture_desc_5"),
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("tempreture_desc_6"),
                    ),
                    Text(sh.getLanguageResource("tempreture_desc_6_1"),
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("tempreture_desc_7"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      "assets/images/temperature-test-img.png",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("tempreture_desc_8"),
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("tempreture_desc_9"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("tempreture_desc_10"),
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("tempreture_desc_11"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("tempreture_desc_12"),
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("tempreture_desc_13"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("tempreture_desc_14"),
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("tempreture_desc_15"),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 0),
    );
  }
}
