import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:photo_view/photo_view.dart';

import '../shared/bottom-menu.dart';

class WeightDescriptionPage extends StatefulWidget {
  const WeightDescriptionPage({super.key});

  @override
  State<WeightDescriptionPage> createState() => _WeightDescriptionPageState();
}

class _WeightDescriptionPageState extends State<WeightDescriptionPage> {
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
                    Text("", style: articleTitle),
                    Text("Welche Rolle spielt das Körpergewicht?",
                        style: articleTitle),
                    Text(
                        "Ein gesundes Körpergewicht ist von entscheidender Bedeutung für chronisch kranke Patienten, da es das Risiko von Komplikationen verringern kann. Übergewicht kann das Fortschreiten bestimmter Krankheiten wie Diabetes, Herzerkrankungen und Gelenkproblemen verschlimmern. Ein gesundes Gewicht kann auch die Effektivität der medizinischen Behandlung verbessern und die allgemeine Lebensqualität steigern."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Was ist ein gesundes Körpergewicht? ",
                        style: articleTitle),
                    Text(
                        "Ein gesundes Körpergewicht kann individuell unterschiedlich sein und hängt von verschiedenen Faktoren ab, einschließlich Geschlecht, Körpergröße, Alter, Körperzusammensetzung und spezifischen Gesundheitszuständen. Bei chronisch kranken Patienten kann ein gesundes Körpergewicht auch in Bezug auf ihre spezifische Erkrankung definiert werden. Es ist wichtig, dass die Gewichtsziele in enger Absprache mit dem behandelnden Arzt oder Ernährungsexperten festgelegt werden, um die individuellen Bedürfnisse und Gesundheitsziele des Patienten zu berücksichtigen."),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "Welche Rolle spielt die Überwachung des Körpergewichts?",
                        style: articleTitle),
                    Text(
                        "Die regelmäßige Überwachung des Körpergewichts ist wichtig, um Veränderungen frühzeitig zu erkennen. Chronisch kranke Patienten sollten ihr Gewicht im Auge behalten, um zu vermeiden, dass es sich unkontrolliert erhöht oder verringert. Dies kann auf eine Verschlechterung des Gesundheitszustands oder unerwünschte Nebenwirkungen der Behandlung hinweisen. Die Verwendung eines zuverlässigen Waage zu Hause und das Festhalten der Gewichtsdaten in einem Tagebuch oder einer App kann dabei helfen, Trends und Muster zu identifizieren und bei Bedarf rechtzeitig medizinische Hilfe in Anspruch zu nehmen. "),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Körpergewicht verstehen: Body-Mass-Index",
                        style: articleTitle),
                    Text(
                        "Ein weit verbreiteter Ansatz zur Bewertung des Körpergewichts ist der Body-Mass-Index (BMI). Der BMI berechnet sich, indem das Körpergewicht in Kilogramm durch das Quadrat der Körpergröße in Metern geteilt wird. Ein BMI zwischen 18,5 und 24,9 gilt in der Regel als normalgewichtig und mit einem geringeren Risiko für bestimmte Erkrankungen verbunden. Eine gängige Methode zur Beurteilung des Körpergewichts ist der Body-Mass-Index (BMI). Der BMI berechnet sich aus dem Verhältnis von Körpergewicht (in Kilogramm) zu Körpergröße (in Metern) im Quadrat und kann dabei helfen, Übergewicht oder Untergewicht festzustellen."),
                    Text(
                      "Die Formel zur Berechnung des BMI lautet: \n\n\t    BMI = Körpergewicht (kg) / (Körpergröße (m))²\n\n Zum Beispiel hätte eine Person mit einem Gewicht von 70 kg und einer Körpergröße von 1,75 m einen BMI von:     \n\n    \t BMI = 70 kg / (1,75 m)² = 22,86\n\n Der erhaltene Wert des BMI kann dann anhand von Normbereichen oder Referenzwerten interpretiert werden, um festzustellen, ob das Gewicht im normalen, unter- oder übergewichtigen Bereich liegt.",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Mögliche Anzeichen für Übergewicht (Adipositas)",
                        style: articleTitle),
                    Text(
                        "Adipositas, auch als Fettleibigkeit bekannt, tritt auf, wenn sich im Körper übermäßige Fettmasse ansammelt. Es gibt verschiedene Anzeichen, die auf Adipositas hinweisen können, darunter ein BMI über 30, ein erhöhter Taillenumfang, Atembeschwerden, Gelenkschmerzen, erhöhtes Risiko für Herz-Kreislauf-Erkrankungen und Diabetes. Es ist wichtig, Übergewicht frühzeitig zu erkennen und geeignete Maßnahmen zu ergreifen, um gesundheitliche Probleme zu vermeiden."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Mögliche Anzeichen für Untergewicht",
                        style: articleTitle),
                    Text(
                        "Untergewicht tritt auf, wenn eine Person ein Gewicht hat, das unter dem für ihre Größe und ihren Körperbau empfohlenen Bereich liegt. Mögliche Anzeichen für Untergewicht können ein niedriger BMI, sichtbare Rippen oder Wirbelsäule, Müdigkeit, geschwächtes Immunsystem, Haarausfall und ein allgemeiner Mangel an Energie sein. Untergewicht kann auf verschiedene Faktoren wie unzureichende Nahrungsaufnahme, bestimmte Krankheiten oder Essstörungen zurückzuführen sein."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Veränderungen im Körpergewicht und ihre Ursachen",
                        style: articleTitle),
                    Text(
                        "Krankhafte Veränderungen im Körpergewicht können verschiedene Ursachen haben. Ein plötzlicher Gewichtsverlust kann beispielsweise auf Schilddrüsenprobleme oder eine Essstörung hinweisen. Ein plötzlicher Gewichtsanstieg kann auf eine übermäßige Kalorienzufuhr, Hormonstörungen oder Flüssigkeitsretention zurückzuführen sein. Es ist wichtig, unerklärliche Gewichtsveränderungen ärztlich abklären zu lassen, um die zugrunde liegende Ursache zu ermitteln und gegebenenfalls eine geeignete Behandlung einzuleiten."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Folgende Einteilung nimm unsere App vor: "),
                    Image.asset(
                      "assets/images/weight-text-img.png",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Maßnahmen bei Über- und Untergewicht",
                        style: articleTitle),
                    Text(
                        "Bei Über- oder Untergewicht sollten geeignete Maßnahmen ergriffen werden, um das Körpergewicht in einen gesunden Bereich zu bringen. Bei Übergewicht kann eine Kombination aus gesunder Ernährung, regelmäßiger körperlicher Aktivität und Verhaltensänderungen hilfreich sein. Bei Untergewicht ist es wichtig, eine ausgewogene Ernährung mit ausreichender Kalorien- und Nährstoffzufuhr zu gewährleisten. In beiden Fällen kann es ratsam sein, einen Arzt, Ernährungsberater oder einen anderen Fachexperten zu konsultieren, um individuelle Empfehlungen und Unterstützung zu erhalten."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Langzeitfolgen", style: articleTitle),
                    Text(
                        "Gewichtsprobleme können erhebliche Auswirkungen auf die Gesundheit haben, sowohl bei Übergewicht als auch bei Untergewicht. Langfristig können diese Zustände zu verschiedenen gesundheitlichen Komplikationen führen. In diesem Artikel werden die Langzeitfolgen von Übergewicht und Untergewicht näher erläutert."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Langzeitfolgen bei Übergewicht:",
                        style: articleTitle),
                    Text(
                        "\t 1.	Herz-Kreislauf-Erkrankungen: Übergewicht erhöht das Risiko für Herzkrankheiten wie koronare Herzkrankheit, Herzinfarkt, Schlaganfall und Bluthochdruck. Das überschüssige Körperfett kann zu einer Ablagerung von Plaque in den Arterien führen und die Durchblutung beeinträchtigen. \n\t 2.	Typ-2-Diabetes: Übergewicht ist ein wichtiger Risikofaktor für die Entwicklung von Typ-2-Diabetes. Der Körper kann Insulin möglicherweise nicht effizient verwenden, was zu einem Anstieg des Blutzuckerspiegels führt. \n\t3.	Gelenkprobleme: Das zusätzliche Gewicht belastet die Gelenke, insbesondere die Knie und Hüften. Dies kann zu vorzeitiger Abnutzung des Knorpels und zu Arthritis führen. \n\t 4.	Atemprobleme: Übergewichtige Personen haben ein höheres Risiko für Atemprobleme wie Schlafapnoe, bei der die Atmung während des Schlafs vorübergehend unterbrochen wird."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Langzeitfolgen bei Untergewicht:",
                        style: articleTitle),
                    Text(
                        "\t 1.	Mangelernährung: Untergewicht kann auf eine unzureichende Nährstoffaufnahme hinweisen, was zu Mangelernährung und einem Defizit an wichtigen Vitaminen, Mineralstoffen und Proteinen führen kann.\n\t2.	Osteoporose: Untergewichtige Personen haben ein erhöhtes Risiko für Osteoporose, da der Körper nicht genügend Nährstoffe für den Aufbau und die Stärkung der Knochen erhält.\n\t3.	Muskelschwund: Untergewicht kann zu Muskelabbau führen, was die Kraft, Mobilität und den allgemeinen Gesundheitszustand beeinträchtigen kann.\n\t4.	Hormonelle Probleme: Untergewicht kann zu hormonellen Ungleichgewichten führen, die Menstruationsstörungen bei Frauen und eine verminderte Fruchtbarkeit zur Folge haben können.\n\t5.	Schwächung des Immunsystems: Untergewichtige Personen haben oft ein geschwächtes Immunsystem, was zu häufigeren Infektionen und einer langsameren Genesung führen kann."),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "Es ist wichtig zu beachten, dass die individuellen Auswirkungen von Übergewicht und Untergewicht von verschiedenen Faktoren abhängen, einschließlich der genetischen Veranlagung, des allgemeinen Gesundheitszustands und des Lebensstils. Um die Langzeitfolgen zu minimieren, ist es entscheidend, ein gesundes Körpergewicht anzustreben und bei Bedarf medizinischen Rat einzuholen. Eine ausgewogene Ernährung, regelmäßige körperliche Aktivität und ein gesunder Lebensstil können dazu beitragen, das Gewicht in einem gesunden Bereich zu halten und das Risiko von Komplikationen zu reduzieren.")
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
