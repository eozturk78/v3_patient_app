import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingDescSubpage('Vitalwerte', context),
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
                              .pushNamed('/Temperature-description');
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
                        style: descriptionNotStyle,
                        child: Text('Herzfrequenz')),
                    SizedBox(
                      width: 3,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/temperature-description');
                        },
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
                    Text("Temperatur - Bedeutung, Messung und Auswirkungen",
                        style: articleTitle),
                    Text(
                        "Die Körpertemperatur ist ein wichtiger Parameter zur Beurteilung des Gesundheitszustands eines Menschen. In diesem Artikel werden wir die Bedeutung der Körpertemperatur erklären, verschiedene Messmethoden diskutieren und die Auswirkungen von abnormalen Körpertemperaturen auf den Körper betrachten."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Wie wird die Temperatur gemessen?",
                        style: articleTitle),
                    Text(
                        "Die Körpertemperatur kann auf verschiedene Arten gemessen werden. Die gängigste Methode ist die Verwendung eines Thermometers, das unter der Zunge, in der Achselhöhle oder im Rektum platziert wird. Es gibt auch berührungslose Infrarotthermometer, die die Temperatur an der Stirn oder am Ohr messen können."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Temperatur Messwerte verstehen", style: articleTitle),
                    Text(
                        "Die normale Körpertemperatur bei Erwachsenen liegt normalerweise zwischen 36,5°C und 37,5°C. Es kann jedoch individuelle Unterschiede geben, und die Temperatur kann je nach Tageszeit, körperlicher Aktivität und anderen Faktoren leicht variieren."),
                    Text(
                        "Welche Körpertemperaturen sind normal, krankhaft und kritisch?",
                        style: articleTitle),
                    Text(
                        "Eine Körpertemperatur unter 36°C wird als Unterkühlung bezeichnet und kann lebensbedrohlich sein. Eine Körpertemperatur über 38°C wird als Fieber bezeichnet und kann auf eine Infektion oder eine andere Erkrankung hinweisen. Eine Körpertemperatur über 40°C gilt als hoch und erfordert medizinische Aufmerksamkeit."),
                    SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      "assets/images/temperature-test-img.png",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "Woher kommt die Körpertemperatur und wie wird sie reguliert?",
                        style: articleTitle),
                    Text(
                        "Die Körpertemperatur wird durch den Stoffwechsel und die Wärmeerzeugung im Körper, insbesondere durch den Energieverbrauch der Zellen, beeinflusst. Der Körper reguliert seine Temperatur durch den Wärmeverlust über die Haut, die Schweißproduktion und die Kontraktion der Blutgefäße."),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "Mögliche Anzeichen für erhöhte und zu niedrige Körpertemperatur?",
                        style: articleTitle),
                    Text(
                        "Erhöhte Körpertemperatur kann mit Symptomen wie Schüttelfrost, Schweißausbrüchen, Kopfschmerzen, Müdigkeit und Muskelschmerzen einhergehen. Eine zu niedrige Körpertemperatur kann zu Schüttelfrost, Verwirrung, Schwäche, Bewusstseinsverlust und langsamer Herzfrequenz führen."),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "Krankheitsbilder einer erhöhten und einer zu niedrigen Körpertemperatur inklusive der Langzeitfolgen",
                        style: articleTitle),
                    Text(
                        "Erhöhte Körpertemperatur kann auf Infektionen, Entzündungen oder andere Erkrankungen wie Grippe, Lungenentzündung oder Hitzschlag hinweisen. Langfristige Auswirkungen können von der zugrunde liegenden Ursache abhängen und reichen von Komplikationen bis hin zu Organversagen. Eine zu niedrige Körpertemperatur kann auf Hypothermie, Schilddrüsenprobleme oder Nebenniereninsuffizienz hinweisen und kann zu Erfrierungen, Gewebeschäden oder sogar zum Tod führen."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Therapieoptionen", style: articleTitle),
                    Text(
                        "Die Behandlung von abnormalen Körpertemperaturen hängt von der zugrunde liegenden Ursache ab. Bei Fieber können Medikamente eingenommen werden, um die Temperatur zu senken. Bei Unterkühlung ist es wichtig, den Körper langsam wieder aufzuwärmen und medizinische Hilfe zu suchen. Die genaue Therapie richtet sich nach der individuellen Situation und sollte in Absprache mit einem medizinischen Fachpersonal erfolgen. Es ist wichtig, Veränderungen der Körpertemperatur zu beachten und bei anhaltenden oder schwerwiegenden Symptomen ärztlichen Rat einzuholen, um eine genaue Diagnose und geeignete Behandlung zu erhalten.")
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
