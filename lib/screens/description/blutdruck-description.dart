import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:photo_view/photo_view.dart';

import '../shared/bottom-menu.dart';

class BlutdruckDescriptionPage extends StatefulWidget {
  const BlutdruckDescriptionPage({super.key});

  @override
  State<BlutdruckDescriptionPage> createState() =>
      _BlutdruckDescriptionPageState();
}

class _BlutdruckDescriptionPageState extends State<BlutdruckDescriptionPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Vitalwerte!', context),
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
                    Text("Blutdruck: Was ist das?", style: articleTitle),
                    Text(
                        "Der Blutdruck stellt den messbaren Druck des Blutes in den Arterien während der Durchpumpung des Körpers durch das Herz dar. Es ist wichtig zu beachten, dass der Blutdruck und die Herzfrequenz zwei verschiedene Messgrößen sind. Die Herzfrequenz gibt an, wie schnell das Herz schlägt, während der Blutdruck den Druck in den Arterien angibt. \n \n Der Blutdruck unterliegt natürlichen Schwankungen im Laufe des Tages und der Nacht. Eine Besorgnis erregende Situation tritt jedoch auf, wenn der Gesamt-Blutdruck dauerhaft hoch ist, selbst im Ruhezustand."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Wie wird der Blutdruck gemessen?",
                        style: articleTitle),
                    Text(
                        "Die Messung des Blutdrucks erfolgt durch Verwendung eines speziellen Blutdruckmessgeräts, das mithilfe einer Manschette um den Oberarm erfolgt. Die Manschette wird entweder manuell mit einem Handgerät von einer Ärztin oder einem Arzt aufgepumpt oder automatisch mithilfe einer elektronischen Maschine. \n \n Die Messung sollte idealerweise im Sitzen erfolgen, wobei der Arm entspannt auf einem Tisch in Herzhöhe liegt. Es ist ratsam, vor der Blutdruckmessung einige Minuten ruhig zu sitzen, um ein möglichst genaues Ergebnis zu erzielen..."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Blutdruckwerte verstehen?", style: articleTitle),
                    Text(
                        "Der Blutdruck wird durch zwei Zahlenwerte in der Einheit Millimeter-Quecksilbersäule (mmHg) angegeben. Der erste Wert wird als systolischer Druck bezeichnet und misst den Druck, mit dem das Blut durch den Körper gepumpt wird. Der untere Wert wird als diastolischer Druck bezeichnet und steht für den Widerstand, dem dieser Blutfluss in den Blutgefäßen entgegenwirkt.\n\nBeispielweise bedeutet ein Blutdruckwert von 120 zu 80 (geschrieben als 120/80), dass der systolische Druck 120 mmHg und der diastolische Druck 80 mmHg beträgt. Nach der Messung können die Ergebnisse anhand einer Blutdruck-Tabelle eingeordnet werden."),
                    Image.asset(
                      "assets/images/blutdruck-text-img.png",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Welche Blutdruckwerte sind normal?",
                        style: articleTitle),
                    Text(
                        "Als allgemeine Richtwerte gelten:\n •	Normale Blutdruckwerte: zwischen 100/60 mmHg und 140/90 mmHg\n•	Bluthochdruck: 140/90 mmHg oder höher\n•	Niedriger Blutdruck (Hypotonie): 100/60 mmHg und niedriger"),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Woher kommt Bluthochdruck?", style: articleTitle),
                    Text(
                        "Bluthochdruck bedeutet, dass das Herz mehr Anstrengung aufbringen muss, um das Blut durch den Körper zu pumpen. Bei den meisten Menschen gibt es keine spezifische Ursache für Bluthochdruck. Es gibt jedoch mehrere Haupt-Risikofaktoren, darunter:\n•	Übergewicht \n•	ungesunde, salzreiche Ernährung\n•	zu viel Alkohol\n•	zu wenig Bewegung\n•	Stress und Ängste\n•	genetische Veranlagung zu Bluthochdruck in der Familie\n•	bestimmte Psychopharmaka, die Antibabypille und andere Medikamente"),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "Manchmal ist Bluthochdruck die Folge einer anderen zugrunde liegenden Erkrankung. Dies wird als sekundärer Bluthochdruck bezeichnet. Zum Beispiel kann eine übermäßige Produktion von Hormonen aus den Nebennieren einen hohen Blutdruck verursachen. Zu den Erkrankungen, die sekundären Bluthochdruck verursachen können, gehören Diabetes, Nierenerkrankungen und das Schlafapnoe-Syndrom. Auch in der Schwangerschaft kann sich Bluthochdruck entwickeln. Er tritt in der Regel ab der 20. Schwangerschaftswoche auf und verschwindet innerhalb von 6 Wochen nach der Geburt."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Mögliche Anzeichen für Bluthochdruck",
                        style: articleTitle),
                    Text(
                        "In der Regel treten bei Menschen mit Bluthochdruck keine Symptome auf. Daher ist es von großer Bedeutung, den Blutdruck regelmäßig zu messen. Einige Menschen können jedoch Kopfschmerzen, Nasenbluten, Übelkeit, Müdigkeit, Nervosität, Kurzatmigkeit oder Schwindel verspüren."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Langzeitfolgen von Bluthochdruck",
                        style: articleTitle),
                    Text(
                        "Wenn Bluthochdruck nicht langfristig kontrolliert wird, kann er das Risiko für Herz-Kreislauf-Erkrankungen wie Herzinsuffizienz, Schlaganfälle und Herzinfarkte erhöhen. Auch das Risiko für Nierenerkrankungen und bestimmte Formen von Demenz steigt. Dies liegt daran, dass Bluthochdruck eine zusätzliche Belastung für das Herz, die Blutgefäße und andere Organe wie das Gehirn, die Augen und die Nieren darstellt."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Wie man Bluthochdruck unter Kontrolle bekommt",
                        style: articleTitle),
                    Text(
                        "Mit einfachen Änderungen des Lebensstils können die Blutdruckwerte gesenkt werden:"),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Gesundes Körpergewicht:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                        "Eine Gewichtszunahme erhöht auch den Blutdruck. Das Halten eines gesunden Gewichts kann dazu beitragen, einen gesunden Blutdruck aufrechtzuerhalten. Ein hoher Taillen-Hüft-Quotient (THQ) kann ebenfalls auf ein erhöhtes Risiko hinweisen. Dieser wird berechnet, indem der Taillenumfang (in cm) durch den Hüftumfang (in cm) geteilt wird."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Mehr Obst, Gemüse und Vollkornprodukte:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                        "Studien zeigen, dass die DASH-Diät und die Mittelmeer-Diät helfen können, den Blutdruck und den Cholesterinspiegel zu kontrollieren und das Risiko von Herzerkrankungen zu senken. Beide Diäten sind reich an Obst, Gemüse und Vollkornprodukten und enthalten wenig gesättigte Fettsäuren und rotes Fleisch."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Reduzierter Salzkonsum:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                        "Ein übermäßiger Salzkonsum kann den Blutdruck erhöhen. Die tägliche Salzaufnahme sollte 6 g (ungefähr 1 Teelöffel) nicht überschreiten. Es ist wichtig zu bedenken, dass Fertigprodukte oft verstecktes Salz enthalten."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Mehr Bewegung im Alltag:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                        "Regelmäßige körperliche Aktivität ist wichtig, um die Gesundheit der Blutgefäße und des Herzens zu erhalten. Zu den Aktivitäten, die sich positiv auf den Blutdruck auswirken, gehören Radfahren, Schwimmen, Tanzen, Gartenarbeit, Tennis und Joggen. Es gibt klare Belege dafür, dass bereits ein 30-minütiger Spaziergang am Morgen den Blutdruck genauso effektiv senken kann wie die Einnahme von Medikamenten."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Mäßiger Alkoholkonsum: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                        "Frauen sollten nicht mehr als ein Glas Alkohol pro Tag trinken, während Männer auf höchstens zwei Gläser begrenzt sein sollten. Außerdem sollten alle mindestens an zwei Tagen in der Woche komplett auf Alkohol verzichten. Untersuchungen haben gezeigt, dass sich ein hoher Blutdruck schnell umkehren kann, wenn starke Trinker ihren Alkoholkonsum um etwa 50 % reduzieren."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Rauchfrei leben:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                        "Rauchen führt wie Bluthochdruck zu einer Verengung der Arterien und erhöht somit das Risiko für Herzinfarkt oder Schlaganfall erheblich. Durch das Aufgeben des Rauchens wird das Risiko für diese Krankheiten gesenkt.."),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Was ist mit niedrigem Blutdruck?",
                        style: articleTitle),
                    Text(
                        "Niedriger Blutdruck kann Symptome wie Schwindel, verschwommenes Sehen, Ohnmachtsgefühle, Übelkeit oder Schwäche verursachen. Ein niedriger Blutdruck tritt häufig während der Schwangerschaft auf und kann auch eine Nebenwirkung bestimmter Medikamente oder eine Begleiterscheinung von Erkrankungen sein."),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "Niedriger Blutdruck verursacht nicht immer Symptome, und die Behandlung richtet sich nach der zugrunde liegenden Ursache. Es gibt jedoch einige Maßnahmen, die helfen können, die Symptome zu lindern, wie das Tragen von Stützstrümpfen, um den Blutdruck zu erhöhen und die Durchblutung zu verbessern, ausreichend Flüssigkeit zu trinken, da Flüssigkeitsmangel den Blutdruck senken kann, und eine erhöhte Salzzufuhr (mehr als die empfohlenen 6 Gramm), da dies das Blutvolumen und somit den Blutdruck steigern kann..")
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
