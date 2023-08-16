import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:photo_view/photo_view.dart';

import '../shared/bottom-menu.dart';

class SaturationDescriptionPage extends StatefulWidget {
  const SaturationDescriptionPage({super.key});

  @override
  State<SaturationDescriptionPage> createState() =>
      _SaturationDescriptionPageState();
}

class _SaturationDescriptionPageState extends State<SaturationDescriptionPage> {
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
                              .pushNamed('/saturation-description');
                        },
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
                    Text("Was ist die Sauerstoffsättigung im Blut?",
                        style: articleTitle),
                    Text(
                        "Sauerstoff ist überlebenswichtig und für jede Körperzelle und -funktion notwendig. Damit unser Körper mit genug Sauerstoff versorgt wird, muss das Zusammenspiel aus Atmung, Kreislauf und der Gewebsdurchblutung stimmen. Die Sauerstoffsättigung gibt den Sauerstoffgehalt im Blut an."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Wie wird die Sauerstoffsättigung im Blut gemessen?",
                        style: articleTitle),
                    Text(
                        "Die Sauerstoffsättigung im Blut wird üblicherweise mit einem Pulsoximeter gemessen. Ein Pulsoximeter ist ein medizinisches Gerät, das an einem Finger, Ohrläppchen oder Zeh platziert wird. Es verwendet zwei Lichtquellen - eine rote und eine infrarote - sowie einen Sensor, um den Sauerstoffgehalt im Blut zu messen. Das rote Licht wird vom sauerstoffreichen Hämoglobin absorbiert, während das infrarote Licht vom sauerstoffarmen Hämoglobin absorbiert wird. Der Sensor erfasst die Lichtintensität und berechnet daraus die Sauerstoffsättigung."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Wie hoch ist die normale Sauerstoffsättigung?",
                        style: articleTitle),
                    Text(
                        "Eine Sauerstoffsättigung von 95% bis 100% wird als normal angesehen. Eine Sauerstoffsättigung unter 90% wird als niedrig und potenziell abnormal betrachtet. Bei Werten unter 85% besteht ein erhöhtes Risiko für Gewebeschäden aufgrund von Sauerstoffmangel. Es ist wichtig zu beachten, dass individuelle Unterschiede und bestimmte medizinische Bedingungen die normalen Sauerstoffsättigungswerte beeinflussen können. Eine ärztliche Beurteilung ist erforderlich, um den individuellen Zustand zu bewerten."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Folgende Einteilung nehmen wir in unserer App vor"),
                    SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      "assets/images/saturation-text-img.png",
                    ),
                    Text("Wie entsteht eine niedrige Sauerstoffsättigung?",
                        style: articleTitle),
                    Text(
                        "Für zu niedrige Sättigungswerte kann eine Hypoventilation, also eine zu flache Atmung, verantwortlich sein. Dadurch steht in den Lungenbläschen nicht genug Sauerstoff für den Gasaustausch zur Verfügung. Es kann auch die Lungendurchblutung gestört sein, wodurch sich nicht genug Blut am Gasaustausch beteiligen kann. Auch bei einer Lungenentzündung kann die Sauerstoffsättigung erniedrigt sein. Die Entzündung führt dazu, dass die Wand der Lungenbläschen sich verdickt. Der Abstand zwischen der Luft und dem Blut in den Kapillaren wird dadurch größer, was den Übergang der Sauerstoff- und Kohlenstoffdioxidteilchen einschränkt. Es geht weniger Sauerstoff von den Lungenbläschen ins Blut über und die Sauerstoffsättigung sinkt."),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "Andere Erkrankungen, die mit einer erniedrigten Sauerstoffsättigung einhergehen, sind:"),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "\t•	Asthma bronchiale\n\t•	chronisch obstruktive Lungenerkrankungen (COPD)\n\t•	Lungenödeme\n\t•	Lungenembolien"),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Anzeichen einer zu niedrigen Sauerstoffsättigung",
                        style: articleTitle),
                    Text(
                        "Die Leistungsfähigkeit des Körpers ist stark abhängig von einem ausreichend großen Angebot an Sauerstoff. Ist dieses nicht gegeben, zeigt sich das durch folgende Symptome:"),
                    Text(
                        "\t•	geringe Belastbarkeit\n\t•	Kurzatmigkeit\n\t•	Müdigkeit und Abgeschlagenheit\n\t•	bläulich verfärbte Lippen und Haut (Zyanose)\n\t•	Schwächeanfälle und Ohnmacht"),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "Wie kann man die Sauerstoffsättigung im Blut verbessern?",
                        style: articleTitle),
                    Text(
                        "Wer selbst etwas für eine gute Sauerstoffversorgung des eigenen Körpers tun und diese erhöhen möchte, kann sich mit körperlichem Training und Atemübungen fit halten. Der Körper passt sich der Belastung auf vielen Ebenen an, so wird die Durchblutung der Muskulatur und der Lunge gefördert, das Herz wird gekräftigt, der Blutdruck sinkt und die maximale Sauerstoffaufnahme durch die Lunge kann deutlich vergrößert werden. "),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Langzeitfolgen von niedriger Sauerstoffsättigung",
                        style: articleTitle),
                    Text(
                        "Eine langfristig niedrige Sauerstoffsättigung kann zu verschiedenen gesundheitlichen Problemen führen. Wenn Gewebe und Organe nicht ausreichend mit Sauerstoff versorgt werden, kann dies zu dauerhaften Schäden führen. Organe wie das Herz, das Gehirn und die Nieren sind besonders empfindlich gegenüber Sauerstoffmangel. Eine unzureichende Sauerstoffversorgung kann das Risiko für Herz-Kreislauf-Erkrankungen, Gedächtnisstörungen, Nierenprobleme und andere gesundheitliche Komplikationen erhöhen. Es ist wichtig, eine langfristig niedrige Sauerstoffsättigung ärztlich zu behandeln und die zugrunde liegende Ursache zu behandeln, um Langzeitfolgen zu vermeiden.")
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
