import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v3_patient_app/shared/shared.dart';
import '../shared/shared.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});
  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditionsPage> {
  Shared sh = Shared();
  @override
  void initState() {
    // TODO: implement initState
    checkRemeberMe();
    super.initState();
    sh.openPopUp(context, 'terms-and-conditions');
  }

  checkRemeberMe() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingWithoutProfile('Nutzungsbedingungen', context),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Autoren",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "Yanick Röhricht",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Dokumentname",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Nutzungsbedingungen",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Status",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "In Bearbeitung | Prüfung | Qualitätssicherung | Freigabe",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Version",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "0.1",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Datum",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "20.06.2023",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Bearbeitungsart & Änderungen",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Bearbeiter",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Yanick Röhricht",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "NUTZUNGSBEDINGUNGEN\nder iMedCom v3-imc-Patienten-App",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Anbieter der App:  „iMedCom v3“:\n\n\niMedCom v3 GmbH\nWeinbergweg 23\n06120 Halle an der Saale\nDeutschland\n\n\nTel: +49 345 6824403\nInternet: https://iMedCom v3.de/\nE-Mail: kontakt@iMedCom v3.de \n\n\nVertretungsberechtigter Geschäftsführer: Burghard Vogel\nRegistergericht: Amtsgericht Halle (Saale)\nRegisternummer: HRB 25641\n",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "§1 Geltungsbereich",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '(1)	Die iMedCom v3-App (im Folgenden als "App" oder "iMedCom v3" bezeichnet) sowie die damit verbundenen Dienste, Inhalte und Services werden von der iMedCom v3 GmbH, Weinbergweg 23, 06120 Halle an der Saale betrieben. \n\n(2)	Die Nutzung von iMedCom v3 und ihren Inhalten erfordert die vorherige ausdrückliche Einwilligung in diese Nutzungsvereinbarung und die Kenntnisnahme der Gebrauchsanweisung. Für die rechtmäßige Verarbeitung der  personenbezogenen Daten im Rahmen der bestimmungsgemäßen iMedCom v3 Nutzung ist zudem die Abgabe einer ausdrücklichen Einwilligung des betroffenen Nutzers erforderlich. \n\n(3)	Der Schutz der persönlichen Nutzerdaten hat für iMedCom v3 höchste Priorität. Wir handeln in Übereinstimmung mit den geltenden Datenschutzbestimmungen und setzen uns für die Sicherheit der Daten ein. Diese Nutzungsvereinbarung informiert die Nutzer über den Anwendungsbereich, Haftungsfragen und Verantwortlichkeiten.\n\n(4)	Alle von iMedCom v3 angebotenen Leistungen stellen weder eine ärztliche Beratung noch eine medizinische Diagnose dar. Sie sind kein Ersatz für eine Untersuchung oder Behandlung durch einen Arzt oder Therapeuten. Bei medizinischen Rückfragen wird dringend empfohlen, einen Arzt zu konsultieren.\n\n(5)	Aus Gründen der Darstellung und Lesbarkeit wurde in dieser Nutzungsvereinbarung und in allen unseren Produkten die männliche Form verwendet. Dies dient ausschließlich der besseren Lesbarkeit und beinhaltet keine Diskriminierungsabsicht. Es sind immer alle Geschlechter gleichermaßen gemeint und einbezogen.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "§ 2 Bereitstellung der App und Benutzerkonto",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '(1)	Um iMedCom v3 nutzen zu können, müssen Sie die App aus dem Apple Store oder Google Store herunterladen und erfolgreich installieren. Die Bedingungen für den Download von iMedCom v3 unterliegen den Bestimmungen des entsprechenden Stores. Damit die Installation reibungslos verläuft und die App ohne Probleme funktioniert, sind bestimmte Hardware- und Softwareversionen erforderlich. Die genauen Anforderungen finden Sie in der Gebrauchsanweisung. Bitte beachten Sie, dass eine störungsfreie Nutzung von iMedCom v3 nur gewährleistet werden kann, wenn Sie diese Voraussetzungen erfüllen.\n\n(2)	Durch Abschluss des Online-Registrierungsvorgangs und Erstellung eines Profils kommt ein Nutzungsvertrag mit dem Anbieter zustande.\n\n(3)	Für die Erstellung eines Profils ist die Erstellung eines Benutzerkontos erforderlich. Dieses besteht aus einem Usernamen und einem Kennwort („Login-Daten“). Die Erstellung eines Benutzerkontos ist nur unter Angabe einer aktuellen E-Mail-Adresse des Nutzers möglich. Diese E-Mail-Adresse dient zugleich der Kommunikation mit dem Anbieter .). \n\n(4)	Der Nutzer ist verpflichtet, mit den Log-in-Daten sorgfältig umzugehen. Insbesondere ist es dem Nutzer untersagt, die Log-in-Daten Dritten mitzuteilen und/oder Dritten den Zugang zu dem Profil unter Umgehung der Log-in-Daten zu ermöglichen.\n\n(5)	Wenn der Nutzer seine Verpflichtungen gemäß vorstehendem Absatz 4 verletzt und sein Benutzerkonto von Dritten verwendet wird, haftet der Nutzer für sämtliche Aktivitäten, die unter Verwendung seines Benutzerkontos stattfinden. Der Nutzer haftet nicht, wenn er den Missbrauch seines Benutzerkontos nicht zu vertreten hat. \n\n(6)	Der Nutzer sichert zu, dass die bei Erstellung seines Profils verwendeten Daten („Profil-Daten“) zutreffend und vollständig sind.\n\n(7)	Bei jedweder Kommunikation des Nutzers mit anderen Nutzern entstehen etwaige Vertragsbeziehungen ausschließlich zwischen den beteiligten Nutzern. Der Anbieter  ist weder Stellvertreter noch wird er selbst Vertragspartner.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "§ 3 Nutzung des Profils",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '(1)	Bei der Nutzung des Profils kann der Nutzer verschiedene Dienste in Anspruch nehmen:\n\n•	Der Nutzer hat die Möglichkeit, Inhalte (Text, Fotos, Grafiken, Videos etc.) auf die Plattform hochzuladen (zu publizieren).\n•	Der Nutzer hat die Möglichkeit, Nachrichten an andere Nutzer zu versenden.\n•	Der Nutzer hat die Möglichkeit, Videosprechstunden durchzuführen \n•	Der Nutzer erhält allgemeine und spezielle Informationen zu seinem Vitalwerten und Gesundheitszustand\n\n(2)	Der Anbieter ist jederzeit berechtigt, einzelne Inhalte zu sperren oder zu löschen, zum Beispiel wenn der Verdacht besteht, dass diese gegen geltendes Recht oder Rechte Dritter verstoßen. Es besteht kein Anspruch des Nutzers auf Aufrechterhaltung einzelner Funktionalitäten der Plattform.\n\n(3)	Der Anbieter ist um einen störungsfreien Betrieb der Plattform bemüht. Dies beschränkt sich naturgemäß auf Leistungen, auf die der Anbieter  einen Einfluss hat. Dem Anbieter  ist es unbenommen, den Zugang zu der Plattform aufgrund von Wartungsarbeiten, Kapazitätsbelangen und aufgrund anderer Ereignisse, die nicht in seinem Machtbereich stehen, ganz oder teilweise, zeitweise oder auf Dauer, einzuschränken.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "§ 4 Pflichten des Nutzers",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '(1)	Der Nutzer hat vor Gebrauch von iMedCom v3 die zur Verfügung gestellte Gebrauchsanweisung vollständig zu lesen und bestätigt, dass er diese verstanden hat.\n\n(2)	Der Nutzer verpflichtet sich gegenüber dem Anbieter, keine Inhalte auf die Plattform hochzuladen, die durch ihren Inhalt oder ihre Form oder Gestaltung oder auf sonstige Weise gegen geltendes Recht oder die guten Sitten verstoßen. Insbesondere verpflichtet sich der Nutzer, bei dem Hochladen von Inhalten geltendes Recht (zum Beispiel Straf-, Wettbewerbs- und Jugendschutzrecht) zu beachten und keine Rechte Dritter (zum Beispiel Namens-, Marken-, Urheber-, Bild- und Datenschutzrechte) zu verletzen.\n\n(3)	Sämtliche Datenangaben in iMedCom v3, die sich auf den Nutzer beziehen, korrekt, vollständig und wahrheitsgemäß zu machen. \n\n(4)	Ohne ausdrückliche Zustimmung des Empfängers darf der Nutzer die Plattform nicht verwenden, um Nachrichten werbenden Inhalts an andere Nutzer oder Dritte zu versenden (Spam-Nachrichten).\n\n(5)	Der Nutzer muss jedwede Tätigkeit unterlassen, die geeignet ist, den Betrieb der Plattform oder der dahinterstehenden technischen Infrastruktur zu beeinträchtigen. Dazu zählen insbesondere:\n•	die Verwendung von Software, Scripten oder Datenbanken in Verbindung mit der Nutzung der Plattform;\n•	das automatische Auslesen, Blockieren, Überschreiben, Modifizieren, Kopieren von Daten und/oder sonstigen Inhalten, soweit dies nicht für die ordnungsgemäße Nutzung der Plattform erforderlich ist;\n\n(6)	Sollte es bei der Nutzung der Plattform bzw. ihrer Funktionalitäten zu Störungen kommen, wird der Nutzer den Anbieter  von dieser Störung unverzüglich in Kenntnis setzen. Gleiches gilt, wenn der Nutzer Informationen über von Dritten veröffentlichte Inhalte erlangt, die offensichtlich gegen geltendes Recht oder Rechte Dritter verstoßen.\n\n(7)	Es wird empfohlen, zur Verfügung stehende Updates der Apps auszuführen. Andernfalls kann eine ordnungsgemäße Nutzung und die Genauigkeit der Messergebnisse ggf. nicht gewährleistet werden. Zudem sind auf mobilen Endgeräten alle Sicherheitsvorkehrungen (wie z.B. Passwortschutz, aktuellen Virenschutz) zu treffen, um einen Fremdzugriff oder Datenverlust zu vermeiden.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "§ 5 Zweckbestimmung der iMedCom v3-Patienten-App",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '(1)	Die iMedCom v3-Patienten-App ist eine Software-Anwendung, die speziell für mobile Endgeräte von Patienten und Nutzern mit chronischen Erkrankungen entwickelt wurde. Sie bietet krankheitsspezifische Informationen basierend auf den individuellen Bedingungen des Nutzers. Die App erfasst und zeigt krankheitsspezifische Vitalwerte und Zustände an. Die Übertragung von Vitalparametern wie Herzfrequenz, Blutdruck, Sauerstoffsättigung, Gewicht und Körpertemperatur kann über eine medizinische Messgeräte erfolgen.\n\n(2)	Es ist wichtig zu beachten, dass die App nicht zur Diagnosestellung dient. Ihr Ziel ist es, den Gesundheitszustand, die Lebensqualität und das spezifische Wissen über die Krankheit des Benutzers zu verbessern. Sie fördert das Verständnis der Krankheit und die Therapietreue. Dadurch können Warnsignale und Abweichungen vom Gesundheitszustand frühzeitig erkannt werden. Die App unterstützt Verhaltensänderungen und stärkt die Eigenverantwortung des Benutzers.\n\n(3)	Die App erfasst regelmäßig krankheitsspezifische Informationen und präsentiert sie dem Benutzer in leicht verständlicher Form. Darüber hinaus erinnert sie die Patienten täglich an die Einnahme ihrer Medikamente und befragt sie regelmäßig nach ihrem Wohlbefinden. Basierend auf diesen Informationen und dem individuellen Gesundheits- und Therapieprofil erhält der Benutzer speziell aufbereitete medizinische Informationen. Diese beinhalten Informationen zum Gesundheitszustand, zu spezifischen Symptomen und zur Behandlung. Zusätzlich werden Informationen zu Ernährung, Bewegung und anderen Alltagsthemen über Pop-ups und Nachrichten vermittelt. Dies fördert sowohl die Anpassung des individuellen gesundheitsbezogenen Verhaltens als auch die Früherkennung von Dekompensationen und anderen Verschlechterungen des Gesundheitszustandes.\n\n(4)	Alle Informationen können vom Benutzer exportiert und an den Arzt übermittelt werden, was eine transparente Darstellung des Gesundheitszustandes und der Behandlung über den gewählten Zeitraum ermöglicht. Diese Rückkopplungsschleifen ermöglichen es dem Patienten, aktiver am eigenen Gesundheitsmanagement teilzunehmen und sich darin zu schulen',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "§ 6 Nutzungsrechte",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '(1)	Wir möchten Sie darauf hinweisen, dass die Nutzung unserer App voraussetzt, dass wir die personenbezogenen Daten des Nutzers verarbeiten dürfen. Hierfür benötigen wir eine Einwilligung des Nutzers. Diese Einwilligung kann jederzeit widerrufen werden, hat jedoch keinen Einfluss auf die Rechtmäßigkeit der Verarbeitung, die aufgrund der Einwilligung vor dem Widerruf erfolgt ist. Der Widerruf führt auch nicht dazu, dass die Speicherung oder Verarbeitung personenbezogener Daten aufgrund anderer Rechtsgrundlagen unzulässig wird. Weitere Informationen zum Datenschutz und zu den während der Nutzung anfallenden personenbezogenen Daten (insbesondere sensiblen oder besonderen Kategorien) finden Sie in unserer Datenschutzinformationen. Die Datenschutzinformation ist jederzeit in der App abrufbar.\n\n(2)	Die korrekte Handhabung der medizinischen Endgeräte bei der Übertragung der Vitalparameter erfordert die Beachtung der Gebrauchsanweisung und der Allgemeinen Geschäftsbedingungen (AGB) des jeweiligen Herstellers. Die Nutzung der Geräte erfolgt auf eigene Verantwortung und Gefahr des Benutzers. Vor dem Speichern sollte der Benutzer bei jeder Übertragung die Messwerte auf Richtigkeit und Plausibilität überprüfen.\n\n(3)	Zur erleichterten Selbsteinschätzung des Gesundheitszustandes werden die eingegebenen Werte und ausgewerteten Fragebögen optisch kategorisiert. Dies dient lediglich der visuellen Unterstützung und stellt keine medizinische Diagnose dar. Wenn Sie Beschwerden, Atemnot, (Brust-)Schmerzen, Kreislaufprobleme oder andere medizinisch kritische Situationen haben, wenden Sie sich bitte umgehend an die reguläre ärztliche Versorgung. Im Zweifelsfall sollten Sie sich immer an die reguläre ärztliche Versorgung wenden.\n\n(4)	Alle Ratschläge, die automatisiert oder persönlich gegeben werden, dienen dazu, Sie bei Ihrer Lebensweise und/oder Ihren Entscheidungen zur Bewältigung Ihrer Krankheit zu unterstützen und stellen keine konkreten Handlungsanweisungen dar. Wenn Sie sich in Bezug darauf unsicher fühlen, nutzen Sie bitte immer die reguläre medizinische Versorgung.\n\n(5)	Die Nutzer haben unter „Auszug Ihrer Daten“ die Möglichkeit, alle Messdaten, Umfragen, medizinischen Daten und Diagnosen in einer PDF-Datei zu exportieren',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "§ 7 Haftungsausschluss",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '(1)	Die bereitgestellten Informationen von iMedCom v3 werden sorgfältig geprüft und basieren auf aktuellem Wissensstand. Dennoch liegt die Nutzung von iMedCom v3 und die Befolgung der Handlungsempfehlungen in der alleinigen Verantwortung des Nutzers und erfolgt auf eigenes Risiko. Bei spezifischen Fragen zur Behandlung, Pflege oder bei Beschwerden sollten Sie sich bitte an Ihren Arzt oder Therapeuten wenden.\n\n(2)	iMedCom v3 schließt, soweit gesetzlich zulässig, die Haftung für Sach- und Rechtsmängel aus. In Fällen von Vorsatz oder grober Fahrlässigkeit seitens iMedCom v3 oder eines Erfüllungsgehilfen haftet iMedCom v3 gemäß den gesetzlichen Bestimmungen, wenn dem Nutzer durch die Nutzung der iMedCom v3-App ein Schaden entsteht. Bei Fahrlässigkeit seitens iMedCom v3 oder eines Erfüllungsgehilfen haftet iMedCom v3 nur bei Verletzung von Leben, Körper, Gesundheit oder wesentlicher Vertragspflichten, deren Erfüllung die ordnungsgemäße Durchführung der Nutzungsvereinbarung überhaupt erst ermöglicht, sowie in Fällen einer zwingenden Haftung nach dem Produkthaftungsgesetz. Der Schadensersatzanspruch wegen Verletzung wesentlicher Vertragspflichten ist auf den vorhersehbaren Schaden begrenzt, der für solche Verträge typisch ist.\n\n(3)	iMedCom v3 haftet ausdrücklich nicht für Fehlleistungen Dritter oder des Nutzers, insbesondere in Bezug auf die Funktion und Bedienung der bereitgestellten Software.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "§ 8 Nutzungsdauer",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '(1)	Der Nutzungsvertrag läuft auf unbestimmte Zeit und kann von beiden Seiten jederzeit ohne Einhaltung einer Kündigungsfrist gekündigt werden, ohne dass es eines Grundes bedarf.\n\n(2)	Im Falle einer Kündigung hat der Nutzer keinen Zugriff mehr auf sein Profil und auf hochgeladene Inhalte.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "§ 9 Änderungen der Nutzungsbedingungen",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '(1)	Der Anbieter ist berechtigt, jederzeit Bestimmungen dieser Nutzungsbedingungen mit Wirkung für die Zukunft zu ändern oder zu ergänzen, sofern dies aufgrund von gesetzlichen oder funktionalen Anpassungen der Website geboten ist, zum Beispiel bei technischen Änderungen.\n\n(2)	Eine Änderung oder Ergänzung wird dem Nutzer spätestens vier Wochen vor ihrem Wirksamwerden per App-Benachrichtigung angekündigt, ohne dass die geänderten oder ergänzten Bedingungen im Einzelnen oder die Neufassung der Bedingungen insgesamt übersandt werden müssten; es genügt die Unterrichtung über die vorgenommenen Änderungen oder Ergänzungen. ',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "§ 10 Schlussbestimmungen",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Sollten einzelne Bestimmungen dieses Vertrages unwirksam oder undurchführbar sein oder werden, bleibt davon die Wirksamkeit des Vertrages im Übrigen unberührt. An die Stelle der unwirksamen oder undurchführbaren Bestimmung soll eine alternative Regelung treten, die dem Ziel der unwirksamen oder undurchführbaren am nächsten kommt.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
