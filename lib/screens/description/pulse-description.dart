import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:photo_view/photo_view.dart';

import '../shared/bottom-menu.dart';

class PulseDescriptionPage extends StatefulWidget {
  const PulseDescriptionPage({super.key});

  @override
  State<PulseDescriptionPage> createState() => _PulseDescriptionPageState();
}

class _PulseDescriptionPageState extends State<PulseDescriptionPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingDescSubpage('Vitalwerte!', context),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Vitalwerte - Einteilung und Aussagekraft",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                  "Wir möchten Ihnen wichtige Informationen über die Einstufungen von Vitalwerten bereitstellen. Diese helfen Ihnen bei der Interpretation Ihrer gemessenen Werte und unterstützen Sie ein besseres Verständnis für Ihren Gesundheitszustand zu entwickeln. Weiterhin spielen die tabellarisch aufgeführten Grenzwerte  eine wesentliche Rolle in den Standardeinstellungen des Algorithmus unserer Gesundheit-App. Betreuende Ärzte haben zudem die Möglichkeit, die Grenzwerte individuell auf einzelne Patienten anzupassen."),
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
                        child: Text('Blutdruck')),
                    const SizedBox(
                      width: 3,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/weight-description');
                        },
                        style: descriptionNotStyle,
                        child: Text('Gewicht')),
                    const SizedBox(
                      width: 3,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/saturation-description');
                        },
                        style: descriptionNotStyle,
                        child: Text('Sauerstoffsättigung')),
                    const SizedBox(
                      width: 3,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/pulse-description');
                        },
                        child: Text('Herzfrequenz')),
                    SizedBox(
                      width: 3,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/temperature-description');
                        },
                        style: descriptionNotStyle,
                        child: Text('Temperatur'))
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
                    Text("Was ist die Herzfrequenz?", style: articleTitle),
                    Text(
                        "Die Herzfrequenz ist ein wichtiger Indikator für die Aktivität des Herzens und spielt eine zentrale Rolle bei der Beurteilung der kardiovaskulären Gesundheit. Die Herzfrequenz bezieht sich auf die Anzahl der Herzschläge pro Minute. Sie gibt an, wie oft sich das Herz zusammenzieht und Blut durch den Körper pumpt. Die Herzfrequenz kann variieren und wird von verschiedenen Faktoren beeinflusst, einschließlich körperlicher Aktivität, emotionaler Zustand, Alter und allgemeiner Gesundheitszustand."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Wie wird die Herzfrequenz gemessen?",
                        style: articleTitle),
                    Text(
                        "Die Herzfrequenz kann auf verschiedene Arten gemessen werden. Die gängigste Methode ist die Pulsmessung, bei der der Puls an einer Stelle mit einem Finger oder einem Pulsmesser gefühlt wird. Eine andere Methode ist die Verwendung eines EKG (Elektrokardiogramm), das die elektrischen Aktivitäten des Herzens aufzeichnet und die Herzfrequenz genau bestimmen kann."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Wie schnell schlägt ein gesundes Herz?",
                        style: articleTitle),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "Je nachdem ob die Herzfrequenz niedrig, normal oder erhöht ist, unterscheidet man zwischen:"),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "\t•	Bradykardie: niedrige Herzfrequenz\t•	Normofrequenz: normale Herzfrequenz\t•	Tachykardie: erhöhte Herzfrequenz"),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "Die Herzfrequenz ist von unterschiedlichen Faktoren abhängig, dazu zählen das Alter und die körperliche Verfassung."),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "Bei körperlicher Ruhe wird die Frequenz auch Ruhepuls oder Ruhefrequenz genannt und gibt Auskunft über den Herzzustand. In der unteren Tabelle werden grobe Richtwerte für den Ruhepuls nach Geschlecht, Alter und körperlicher Fitness aufgezeigt. Liegt der gemessene Wert nicht im Normbereich empfehlen wir weitere Untersuchungen bei einem Arzt."),
                    SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      "assets/images/saturation-text-img.png",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "Mögliche Anzeichen für krankhafte Veränderungen der Herzfrequenz",
                        style: articleTitle),
                    Text(
                        "Krankhafte Veränderungen der Herzfrequenz können mit verschiedenen Symptomen einhergehen, darunter Schwindel, Kurzatmigkeit, Brustschmerzen, Ohnmacht oder Herzrhythmusstörungen wie Vorhofflimmern. Eine ärztliche Untersuchung ist erforderlich, um die genaue Ursache abzuklären."),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "In welchem Zusammenhang steht die Herzfrequenz mit einem gesunden Lebensstil?",
                        style: articleTitle),
                    Text(
                        "Liegt die Herzfrequenz über den Richtwerten des Ruhepulses, sollte der Herzmuskel trainiert werden. Eine hohe Herzfrequenz kann ein Zeichen für Stress oder eine schlechte körperliche Verfassung sein. Mit Hilfe von Sport, viel Bewegung und einer gesunden Ernährung kann der Kreislauf und damit der Herzmuskel trainiert werden. Bei anhaltender zu hoher Herzfrequenz kann es sich in wenigen Fällen um eine Herzrhythmusstörung, z. B. Vorhofflimmern handeln. Wird diese nicht behandelt, kann dies einen Schlaganfall begünstigen. Beginnen Sie mit Sport, kann mit Hilfe der Herzfrequenz die gewünschte Intensität bzw. Herzbelastung bezüglich eines Trainingsziels kontrolliert werden. Ein Trainingsziel kann die Stärkung des Herzmuskels und des gesamten Körpers sein, zum Beispiel nach einer Operation. Dabei hilft eine medizinische Pulsuhr beim Sport zur Kontrolle der Herzfrequenz, um die Belastung des Herzens besonders bei Einsteigern nicht zu überschreiten. Denn es gilt: Je höher die körperliche Belastung ist, desto mehr Sauerstoff benötigt der Körper. Das Herz muss nun die Frequenz erhöhen, um genug sauerstoffreiches Blut in den Körper zu pumpen. Bei einem trainierten Sportler benötigt das Herz weniger Schläge, um die gleiche Menge Blut durch den Kreislauf zu pumpen, als bei einem untrainierten Menschen."),
                  ],
                ),
              )
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(0),
    );
  }
}
