import 'dart:async';

import 'package:flutter/material.dart';
import 'package:v3_patient_app/apis/apis.dart';
import 'package:v3_patient_app/colors/colors.dart';
import 'package:v3_patient_app/screens/shared/list-box.dart';
import 'package:v3_patient_app/screens/shared/shared.dart';
import 'package:v3_patient_app/shared/shared.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/bottom-menu.dart';

class WeightDescriptionPage extends StatefulWidget {
  const WeightDescriptionPage({super.key});

  @override
  State<WeightDescriptionPage> createState() => _WeightDescriptionPageState();
}

class _WeightDescriptionPageState extends State<WeightDescriptionPage> {
  Shared sh = Shared();
  @override
  void initState() {
    super.initState();
    sh.openPopUp(context, 'weight-description');
    renewToken();
  }

  Apis apis = Apis();
  renewToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    apis.patientrenewtoken().then((value) async {
      tokenTimeOutSecondDB = value['tokenTimeOutSecond'];
      tokenTimeOutSecond = value['tokenTimeOutSecond'];
      popUpAppearSecond = value['popUpAppearSecond'];
      pref.setString("token", value['token']);
    }, onError: (err) => sh.redirectPatient(err, null));
    sh.openPopUp(context, 'extract-data');
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
                        style: descriptionNotStyle,
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
                    Text("", style: articleTitle),
                    Text(sh.getLanguageResource("body_weight_desc_1"),
                        //"Welche Rolle spielt das Körpergewicht?",
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("body_weight_desc_2"),
                      //  "Ein gesundes Körpergewicht ist von entscheidender Bedeutung für chronisch kranke Patienten, da es das Risiko von Komplikationen verringern kann. Übergewicht kann das Fortschreiten bestimmter Krankheiten wie Diabetes, Herzerkrankungen und Gelenkproblemen verschlimmern. Ein gesundes Gewicht kann auch die Effektivität der medizinischen Behandlung verbessern und die allgemeine Lebensqualität steigern.",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("body_weight_desc_3"),
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("body_weight_desc_4"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("body_weight_desc_5"),
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("body_weight_desc_6"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("body_weight_desc_7"),
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("body_weight_desc_8"),
                    ),
                    Text(
                      sh.getLanguageResource("body_weight_desc_9"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("body_weight_desc_10"),
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("body_weight_desc_11"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("body_weight_desc_12"),
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("body_weight_desc_13"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("body_weight_desc_14"),
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("body_weight_desc_15"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      sh.getLanguageResource("body_weight_desc_16"),
                    ),
                    Image.asset(
                      "assets/images/weight-text-img.png",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("body_weight_desc_17"),
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("body_weight_desc_18"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      sh.getLanguageResource("body_weight_desc_19"),
                      //  "Langzeitfolgen",
                      style: articleTitle,
                    ),
                    Text(
                      sh.getLanguageResource("body_weight_desc_20"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("body_weight_desc_21"),
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("body_weight_desc_22"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("body_weight_desc_23"),
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("body_weight_desc_24"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      sh.getLanguageResource("body_weight_desc_25"),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )), // This trailing comma makes auto-formatting nicer for build methods.
      ////bottomNavigationBar: BottomNavigatorBar(selectedIndex: 0),
    );
  }
}
