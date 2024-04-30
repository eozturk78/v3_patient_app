import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/apis/apis.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:patient_app/shared/shared.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/bottom-menu.dart';

class BlutdruckDescriptionPage extends StatefulWidget {
  const BlutdruckDescriptionPage({super.key});

  @override
  State<BlutdruckDescriptionPage> createState() =>
      _BlutdruckDescriptionPageState();
}

class _BlutdruckDescriptionPageState extends State<BlutdruckDescriptionPage> {
  Shared sh = Shared();
  @override
  void initState() {
    super.initState();
    sh.openPopUp(context, 'blutdruck-description');
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
      appBar:
          leadingDescSubpage(sh.getLanguageResource("vital_signs"), context),
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
                //"Vitalwerte - Einteilung und Aussagekraft",
                sh.getLanguageResource("vital_signs_categorisation"),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                sh.getLanguageResource("vital_signs_desc"),
                //  "Wir möchten Ihnen wichtige Informationen über die Einstufungen von Vitalwerten bereitstellen. Diese helfen Ihnen bei der Interpretation Ihrer gemessenen Werte und unterstützen Sie ein besseres Verständnis für Ihren Gesundheitszustand zu entwickeln. Weiterhin spielen die tabellarisch aufgeführten Grenzwerte  eine wesentliche Rolle in den Standardeinstellungen des Algorithmus unserer Gesundheit-App. Betreuende Ärzte haben zudem die Möglichkeit, die Grenzwerte individuell auf einzelne Patienten anzupassen."),
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
                    Text(sh.getLanguageResource("blood_pressure_desc_1"),
                        style: articleTitle),
                    Text(
                      //    "Der Blutdruck stellt den messbaren Druck des Blutes in den Arterien während der Durchpumpung des Körpers durch das Herz dar. Es ist wichtig zu beachten, dass der Blutdruck und die Herzfrequenz zwei verschiedene Messgrößen sind. Die Herzfrequenz gibt an, wie schnell das Herz schlägt, während der Blutdruck den Druck in den Arterien angibt. \n \n Der Blutdruck unterliegt natürlichen Schwankungen im Laufe des Tages und der Nacht. Eine Besorgnis erregende Situation tritt jedoch auf, wenn der Gesamt-Blutdruck dauerhaft hoch ist, selbst im Ruhezustand.",
                      sh.getLanguageResource("blood_pressure_desc_2"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        //"Wie wird der Blutdruck gemessen?",
                        sh.getLanguageResource("blood_pressure_desc_3"),
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("blood_pressure_desc_4"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("blood_pressure_desc_5"),
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("blood_pressure_desc_6"),
                      //   "Der Blutdruck wird durch zwei Zahlenwerte in der Einheit Millimeter-Quecksilbersäule (mmHg) angegeben. Der erste Wert wird als systolischer Druck bezeichnet und misst den Druck, mit dem das Blut durch den Körper gepumpt wird. Der untere Wert wird als diastolischer Druck bezeichnet und steht für den Widerstand, dem dieser Blutfluss in den Blutgefäßen entgegenwirkt.\n\nBeispielweise bedeutet ein Blutdruckwert von 120 zu 80 (geschrieben als 120/80), dass der systolische Druck 120 mmHg und der diastolische Druck 80 mmHg beträgt. Nach der Messung können die Ergebnisse anhand einer Blutdruck-Tabelle eingeordnet werden.",
                    ),
                    Image.asset(
                      "assets/images/blutdruck-text-img.png",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("blood_pressure_desc_7"),
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("blood_pressure_desc_8"),
                      //"Als allgemeine Richtwerte gelten:\n •	Normale Blutdruckwerte: zwischen 100/60 mmHg und 140/90 mmHg\n•	Bluthochdruck: 140/90 mmHg oder höher\n•	Niedriger Blutdruck (Hypotonie): 100/60 mmHg und niedriger",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("blood_pressure_desc_9"),
                        style: articleTitle),
                    Text(sh.getLanguageResource("blood_pressure_desc_10")
                        //  "Bluthochdruck bedeutet, dass das Herz mehr Anstrengung aufbringen muss, um das Blut durch den Körper zu pumpen. Bei den meisten Menschen gibt es keine spezifische Ursache für Bluthochdruck. Es gibt jedoch mehrere Haupt-Risikofaktoren, darunter:\n•	Übergewicht \n•	ungesunde, salzreiche Ernährung\n•	zu viel Alkohol\n•	zu wenig Bewegung\n•	Stress und Ängste\n•	genetische Veranlagung zu Bluthochdruck in der Familie\n•	bestimmte Psychopharmaka, die Antibabypille und andere Medikamente",
                        ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("blood_pressure_desc_11")),
                    //"Manchmal ist Bluthochdruck die Folge einer anderen zugrunde liegenden Erkrankung. Dies wird als sekundärer Bluthochdruck bezeichnet. Zum Beispiel kann eine übermäßige Produktion von Hormonen aus den Nebennieren einen hohen Blutdruck verursachen. Zu den Erkrankungen, die sekundären Bluthochdruck verursachen können, gehören Diabetes, Nierenerkrankungen und das Schlafapnoe-Syndrom. Auch in der Schwangerschaft kann sich Bluthochdruck entwickeln. Er tritt in der Regel ab der 20. Schwangerschaftswoche auf und verschwindet innerhalb von 6 Wochen nach der Geburt."
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("blood_pressure_desc_12"),
                        style: articleTitle),
                    Text(sh.getLanguageResource("blood_pressure_desc_13")
                        //"In der Regel treten bei Menschen mit Bluthochdruck keine Symptome auf. Daher ist es von großer Bedeutung, den Blutdruck regelmäßig zu messen. Einige Menschen können jedoch Kopfschmerzen, Nasenbluten, Übelkeit, Müdigkeit, Nervosität, Kurzatmigkeit oder Schwindel verspüren.",
                        ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("blood_pressure_desc_14"),
                        //"Langzeitfolgen von Bluthochdruck",
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("blood_pressure_desc_15"),
                      //  "Wenn Bluthochdruck nicht langfristig kontrolliert wird, kann er das Risiko für Herz-Kreislauf-Erkrankungen wie Herzinsuffizienz, Schlaganfälle und Herzinfarkte erhöhen. Auch das Risiko für Nierenerkrankungen und bestimmte Formen von Demenz steigt. Dies liegt daran, dass Bluthochdruck eine zusätzliche Belastung für das Herz, die Blutgefäße und andere Organe wie das Gehirn, die Augen und die Nieren darstellt.",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("blood_pressure_desc_16"),
                        style: articleTitle),
                    Text(
                      sh.getLanguageResource("blood_pressure_desc_17"),
                      // "Mit einfachen Änderungen des Lebensstils können die Blutdruckwerte gesenkt werden:",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("blood_pressure_desc_18"),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(sh.getLanguageResource("blood_pressure_desc_19")
                        //  "Eine Gewichtszunahme erhöht auch den Blutdruck. Das Halten eines gesunden Gewichts kann dazu beitragen, einen gesunden Blutdruck aufrechtzuerhalten. Ein hoher Taillen-Hüft-Quotient (THQ) kann ebenfalls auf ein erhöhtes Risiko hinweisen. Dieser wird berechnet, indem der Taillenumfang (in cm) durch den Hüftumfang (in cm) geteilt wird.",
                        ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("blood_pressure_desc_20"),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(sh.getLanguageResource("blood_pressure_desc_21")),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("blood_pressure_desc_22"),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(sh.getLanguageResource("blood_pressure_desc_23")),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("blood_pressure_desc_24"),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(sh.getLanguageResource("blood_pressure_desc_25")),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("blood_pressure_desc_26"),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(sh.getLanguageResource("blood_pressure_desc_26")),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("blood_pressure_desc_27"),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(sh.getLanguageResource("blood_pressure_desc_28")),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("blood_pressure_desc_29"),
                        style: articleTitle),
                    Text(sh.getLanguageResource("blood_pressure_desc_30")),
                    SizedBox(
                      height: 10,
                    ),
                    Text(sh.getLanguageResource("blood_pressure_desc_31"))
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
