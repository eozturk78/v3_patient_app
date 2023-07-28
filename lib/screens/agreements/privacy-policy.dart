import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../../shared/shared.dart';
import '../shared/shared.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});
  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicyPage> {
  @override
  void initState() {
    // TODO: implement initState
    checkRemeberMe();
    super.initState();
  }

  checkRemeberMe() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingWithoutProfile('Datenschutzinformation ', context),
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
                "Datenschutzinformation für Patienten",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Wir stellen Ihnen neben unserem Online-Angebot eine mobile Patienten-App zur Verfügung, die Sie auf Ihr mobiles Endgerät herunterladen können. Im Folgenden informieren wir über die Verarbeitung personenbezogener Daten bei Nutzung unserer mobilen App.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Diese Datenschutzinformation klärt Sie über die Art, den Umfang und Zweck der Verarbeitung von personenbezogenen Daten innerhalb unserer App auf. Personenbezogene Daten im Sinne der DSGVO sind dabei alle Daten, die auf Sie persönlich beziehbar sind, z. B. Name, Adresse, E-Mail-Adressen, Nutzerverhalten. Welche Daten im Einzelnen verarbeitet und in welcher Weise genutzt werden, richtet sich maßgeblich nach den bei uns in Anspruch genommenen Services.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Wir verwenden in unserer Datenschutzinformation diverse weitere Begriffe im Sinne der DSGVO. Hierzu zählen Begriffe wie Verarbeitung, Einschränkung der Verarbeitung, Profiling, Pseudonymisierung, Verantwortlicher, Auftragsverarbeiter, Empfänger, Dritter, Einwilligung, Aufsichtsbehörde und internationale Organisation. Art. 4 DSGVO können Sie entsprechende Begriffsbestimmungen für diese Begriffe entnehmen.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "1.	Wer ist für die Datenverarbeitung verantwortlich und an wen kann ich mich wenden?:",
                style: agreementHeader,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Verantwortlicher ist: ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "iMedCom GmbH\nWeinbergweg 23\06120 Halle an der Saale\nDeutschland\nkontakt@imedcom.de",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Sie erreichen unseren Datenschutzbeauftragten unter: ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Yanick Röhricht\ndatenschutz@imedcom.de\nwww.alphatech-consulting.de\n",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "2. Wofür verarbeiten wir Ihre Daten (Zweck der Verarbeitung) und auf welcher Rechtsgrundlage?",
                style: agreementHeader,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "2.1 Download der App ",
                style: agreementSubHeader,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Beim Download der App werden bestimmte erforderliche Informationen an den von Ihnen ausgewählten App Store (z.B. Google Play oder Apple App Store) übermittelt.\n\nInsbesondere können dabei der Nutzername, die E-Mail-Adresse, die Kundennummer Ihres Accounts, der Zeitpunkt des Downloads, Zahlungsinformationen sowie die individuelle Gerätekennziffer verarbeitet werden. Die Verarbeitung dieser Daten erfolgt ausschließlich durch den jeweiligen App Store und liegt außerhalb unseres Einflussbereiches.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "2.2 Erstellung eines Nutzeraccounts (Registrierung) und Anmeldung",
                style: agreementSubHeader,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Wenn Sie einen Nutzeraccount erstellen oder sich anmelden, verwenden wir Ihre Zugangsdaten ([E-Mail-Adresse und Passwort]), um Ihnen den Zugang zu Ihrem Nutzeraccount zu gewähren und diesen zu verwalten („Pflichtangaben“). Pflichtangaben im Rahmen der Registrierung sind mit einem Sternchen gekennzeichnet und sind für den Abschluss des Nutzungsvertrages erforderlich. Wenn Sie diese Daten nicht angeben, können Sie keinen Nutzeraccount erstellen.\n\nDie Pflichtangaben verwenden wir, um Sie beim Login zu authentifizieren und Anfragen zur Rücksetzung Ihres Passwortes nachzugehen. Die von Ihnen im Rahmen der Registrierung oder einer Anmeldung eingegebenen Daten werden von uns verarbeitet und verwendet, um Ihre Berechtigung zur Verwaltung des Nutzeraccounts zu verifizieren; die Nutzungsbedingungen der App sowie alle damit verbundenen Rechte und Pflichten durchzusetzen und mit Ihnen in Kontakt zu treten, um Ihnen technische oder rechtliche Hinweise, Updates, Sicherheitsmeldungen oder andere Nachrichten, die etwa die Verwaltung des Nutzeraccounts betreffen, senden zu können.\n\nDiese Datenverarbeitung ist dadurch gerechtfertigt, dass die Verarbeitung für die Erfüllung des Vertrags zwischen Ihnen als Betroffener und uns gemäß Art. 6 Abs. 1 lit. b DSGVO zur Nutzung der App erforderlich ist, oder wir ein berechtigtes Interesse daran haben, die Funktionsfähigkeit und den fehlerfreien Betrieb der App zu gewährleisten, das hier Ihre Rechte und Interessen am Schutz Ihrer personenbezogenen Daten im Sinne von Art. 6 Abs. 1 lit. f DSGVO überwiegt.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "2.3 Nutzung der App",
                style: agreementSubHeader,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Für die technische Funktionsfähigkeit, die Kommunikation und der Beantwortung von Supportanfragen verarbeiten wir Ihre E-Mail-Adresse, Telefonnummer und Zugriffsdaten, z.B. interne Geräte-ID, Version Ihres Betriebssystems, Zeitpunkt des Zugriffs. Technische Zugriffsdaten werden automatisch an uns übermittelt, aber nicht gespeichert, um Ihnen den Dienst und die damit verbundenen Funktionen zur Verfügung zu stellen; die Funktionen und Leistungsmerkmale der App zu verbessern und Missbrauch sowie Fehlfunktionen vorzubeugen und zu beseitigen. \n\nFür den bestimmungsgemäßen Gebrauch der Patienten-App, d.h. der individualisierten Auswertung und der Erstellung eines Gesundheitsprofils verarbeiten wir außerdem Geschlecht, Geburtsdatum, Gewicht und Größe. Diese Datenverarbeitung ist dadurch gerechtfertigt, dass die Verarbeitung für die Erfüllung des Vertrags zwischen Ihnen als Betroffener und uns gemäß Art. 6 Abs. 1 lit. b DSGVO zur Nutzung der App erforderlich ist, oder wir ein berechtigtes Interesse daran haben, die Funktionsfähigkeit und den fehlerfreien Betrieb der App zu gewährleisten und einen interessengerechten Dienst anbieten zu können, dass hier Ihre Rechte und Interessen am Schutz Ihrer personenbezogenen Daten im Sinne von Art. 6 Abs. 1 lit. f DSGVO überwiegt.\n\nDes Weiteren verarbeiten wir Gesundheitsdaten, die Sie uns bei der Nutzung von iMedCom mitteilen, um den bestimmungsgemäßen Gebrauch von iMedCom im Rahmen Ihrer Therapie zu erfüllen. Hierzu gehören Vitalparamater, z.B. Blutdruck, Puls, Sauerstoffsättigung, Gewicht und Temperatur zur Erfassung und Darstellung Ihres individuellen Gesundheitszustands. Dies sind personenbezogene Daten besonderer Kategorien, die gemäß Art. 9 DSGVO (und § 4 Absatz 2 DiGAV) einem besonderen Schutz unterliegen. Rechtsgrundlage für die Verarbeitung der von Ihnen eingegebenen gesundheitsbezogenen Daten ist Art. 6 Abs. 1 lit. a i.V.m. Art. 9 DSGVO. iMedCom vergleicht die von Ihnen gemessenen Vitalparameter sodann mit den Soll-Werten und stellt Ihren individuellen Gesundheitszustand mithilfe von Graphen und Ampeln dar.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "2.3.1 Verwendung Ihres Adressbuchs, Ihrer Fotos oder weiterer Daten",
                style: agreementSubHeader,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Zu Beginn der Nutzung unserer mobilen App bitten wir Sie in einem Pop-up um die Erlaubnis zur Nutzung Ihrer Kamera, Ihres Kalenders, Ihrer Erinnerungen, Ihrer Fotos oder Ihrer Gesundheitsdaten. Wenn Sie die Erlaubnis nicht erteilen, nutzen wir diese Daten nicht. Eventuell können Sie in diesem Fall nicht alle Funktionen unserer mobilen App nutzen. Sie können die Erlaubnis später in den Einstellungen unserer App oder in den Einstellungen Ihres Endgeräts erteilen oder widerrufen. \n\nWenn Sie den Zugriff auf die zuvor genannten Daten gestatten, wird die mobile App nur auf Ihre Daten zugreifen und sie auf unseren Server übertragen, soweit es für die Erbringung der Funktionalität notwendig ist. Ihre Daten werden von uns vertraulich behandelt und gelöscht, wenn Sie die Rechte zur Nutzung widerrufen oder zur Erbringung der Leistungen nicht mehr erforderlich sind und keine rechtlichen Aufbewahrungspflichten bestehen.\n\nRechtsgrundlage für die Verarbeitung der von Ihnen durch Nutzung der App-Funktionen angeforderten Daten ist Art. 6 Abs. 1 S. 1 lit. f DS-GVO.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "2.3.2 Verbesserung der App Funktionalität",
                style: agreementSubHeader,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Auf Grundlage Ihrer freiwilligen Einwilligung verarbeiten wir Ihre technischen und gesundheitsbezogenen Daten, um die Funktionalität und Nutzerfreundlichkeit unserer Gesundheitsapp kontinuierlich zu verbessern.\n\nWir möchten betonen, dass der Schutz Ihrer Daten für uns oberste Priorität hat. Wir ergreifen angemessene technische und organisatorische Maßnahmen, um sicherzustellen, dass Ihre Daten vor unbefugtem Zugriff, Verlust oder Missbrauch geschützt sind. Darüber hinaus werden Ihre Daten nur so lange gespeichert, wie es für die oben genannten Zwecke erforderlich ist, oder wie es gesetzlich vorgeschrieben ist.\n\nDie Auswertung der Daten zur Produktverbesserung erfolgt unter strenger Anonymisierung. Wir entfernen sämtliche personenbezogenen Informationen und stellen sicher, dass die Daten nicht mit einzelnen Nutzern in Verbindung gebracht werden können. Dadurch wird Ihre Privatsphäre und Anonymität gewahrt. Durch die Analyse dieser Daten können wir allgemeine Trends identifizieren, Fehler beheben, neue Funktionen entwickeln und die Leistung der App optimieren\n\nIhre Einwilligung zur Verarbeitung Ihrer gesundheitsbezogenen Daten für die Verbesserung der App-Funktionalität können Sie jederzeit widerrufen.",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "2.3.3 Videosprechstunde",
                style: agreementSubHeader,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Als Patient können Sie an einer iMedCom-Videosprechstunde ohne vorherige Registrierung oder Anmeldung teilnehmen. Nachdem Sie die Einwilligung (Art. 6 Abs. 1 lit. a DSGVO) zur Nutzung Ihrer Kontaktdaten erteilt haben, erhalten Sie per E-Mail oder SMS einen Einladungslink zur Videosprechstunde. iMedCom hat auf diesen Vorgang keinen Einfluss.\n\nIndem Sie den Einladungslink anklicken und sich mit den Nutzungsbedingungen einverstanden erklären sowie die Einwilligung zur Verarbeitung Ihrer Daten erteilen, gelangen Sie in den Wartebereich der Videosprechstunde.\n\nDie Übertragung einer Videosprechstunde erfolgt über das Internet mittels  Peer-to-Peer (Rechner-zu-Rechner) Verbindung, ohne Nutzung eines zentralen Servers. Für die direkte Kommunikation zwischen Patient und Arzt  wird ein STUN-Server (Session Traversal Utilities for NAT) eingesetzt. Indem die beiden beteiligten Rechner ihre öffentliche IP-Adresse an den STUN-Server übermitteln, wird die direkte Kommunikation beider Gesprächspartner ermöglicht. Um das Patientengeheimnis und die ärztliche Schweigepflicht zu wahren, werden die Daten auf dem Endgerät des Patienten verschlüsselt und erst auf dem Endgerät des Arztes wieder entschlüsselt und umgekehrt. Diese Ende-zu-Ende-Verschlüsselung basiert auf der WebRTC-Technologie und verwendet den AES- Verschlüsselungsalgorithmus. \n\nDer iMedCom GmbH ist es durch die eingesetzten Verschlüsslungsverfahren technisch nicht möglich die Kommunikation einer Videosprechstunde zwischen Ihnen und Ihrem Arzt einzusehen oder mitschneiden zu können. Eine Speicherung des Inhalts der Kommunikation zwischen Arzt und Patient erfolgt selbstverständlich nicht. \n\nDie Kommunikation zwischen Arzt und Patient erfolgt authentifiziert und verschlüsselt über unsere Server, die sich ausschließlich in Deutschland befinden",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "3. Wer bekommt meine Daten?",
                style: agreementSubHeader,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Innerhalb unseres Unternehmens erhalten diejenigen Stellen Zugriff auf Ihre Daten, die diese zur Erfüllung unserer vertraglichen und gesetzlichen Pflichten benötigen. Die Daten, die Sie bei der Registrierung angeben, werden innerhalb unseres Unternehmens für interne Verwaltungszwecke einschließlich der gemeinsamen Kundenbetreuung zur Erfüllung unserer vertraglichen und gesetzlichen Pflichten weitergeben.\n\nWenn es zur Aufklärung einer rechtswidrigen bzw. missbräuchlichen Nutzung der App oder für die Rechtsverfolgung erforderlich ist, werden personenbezogene Daten an die Strafverfolgungsbehörden oder andere Behörden sowie ggf. an geschädigte Dritte oder Rechtsberater weitergeleitet. Dies geschieht jedoch nur, wenn Anhaltspunkte für ein gesetzwidriges bzw. missbräuchliches Verhalten vorliegen. Eine Weitergabe kann auch stattfinden, wenn dies der Durchsetzung von Nutzungsbedingungen oder anderen Rechtsansprüchen dient. Wir sind zudem gesetzlich verpflichtet, auf Anfrage bestimmten öffentlichen Stellen Auskunft zu erteilen. Dies sind Strafverfolgungsbehörden, Behörden, die bußgeldbewährte Ordnungswidrigkeiten verfolgen, und die Finanzbehörden.\n\nAuch von uns eingesetzte Auftragsverarbeiter (Art. 28 DSGVO) können zu den oben genannten Zwecken Daten erhalten. Dies sind Unternehmen in den Kategorien IT-Dienstleistungen, Beratung und Consulting.. Sofern wir Daten an unsere Dienstleister weitergeben, dürfen diese die Daten ausschließlich zur Erfüllung ihrer Aufgaben verwenden. Die Dienstleister wurden von uns sorgfältig ausgewählt und beauftragt. Sie sind vertraglich an unsere Weisungen gebunden, verfügen über geeignete technische und organisatorische Maßnahmen zum Schutz der Rechte der betroffenen Personen, gewährleisten ein angemessenes Datenschutzniveau und werden von uns sorgfältig kontrolliert. \n\nEine Weitergabe von Daten an Dritte, die nicht Auftragsverarbeiter sind, erfolgt nur im Rahmen der gesetzlichen Vorgaben. Wir geben die Daten der Nutzer an Dritte nur dann weiter, wenn dies z.B. auf Grundlage des Art. 6 Abs. 1 Satz 1 lit. b) DSGVO für Vertragszwecke oder auf Grundlage berechtigter Interessen gem. Art. 6 Abs. 1 Satz 1 lit. f) DSGVO an einem wirtschaftlichen und effektiven Betrieb unseres Geschäftsbetriebes erforderlich ist oder Sie in die Datenübermittlung eingewilligt haben.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "4. Wie lange werden meine Daten gespeichert?",
                style: agreementSubHeader,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Wir löschen oder anonymisieren Ihre personenbezogenen Daten, sobald sie für die Zwecke, für die wir sie nach den vorstehenden Ziffern erhoben oder verwendet haben, nicht mehr erforderlich sind. Soweit nicht abweichend angegeben speichern wir Ihre personenbezogenen Daten für die Dauer des Nutzungs- bzw. des Vertragsverhältnisses über die App, während welchem wir nach der Löschung Sicherungskopien aufbewahren, soweit diese Daten nicht für die strafrechtliche Verfolgung oder zur Sicherung, Geltendmachung oder Durchsetzung von Rechtsansprüchen länger benötigt werden.\n\nSoweit erforderlich, verarbeiten und speichern wir Ihre personenbezogenen Daten für die Dauer unserer Geschäftsbeziehung, was beispielsweise auch die Anbahnung eines Vertrages über Kontaktformular oder per E-Mail umfasst. \n\nDarüber hinaus unterliegen wir verschiedenen Aufbewahrungs- und Dokumentationspflichten, die sich unter anderem aus dem Handelsgesetzbuch (HGB) und der Abgabenordnung (AO) ergeben. Die dort vorgegebenen Fristen zur Aufbewahrung bzw. Dokumentation betragen zwei bis zehn Jahre. \n\nSchließlich beurteilt sich die Speicherdauer auch nach den gesetzlichen Verjährungsfristen, die zum Beispiel nach den §§ 195 ff. des Bürgerlichen Gesetzbuches (BGB) in der Regel 3 Jahre, in gewissen Fällen aber auch bis zu dreißig Jahre betragen können, wobei die regelmäßige Verjährungsfrist drei Jahre beträgt.\n\nSofern Sie Ihre Rechte als Betroffener geltend machen, speichern wir die Ihnen diesbezüglich erteilte Auskunft bis zum Ablauf der gesetzlichen Verjährungsfrist gemäß § 31 Abs. 2 Nr. 1 OWiG, § 41 Abs. 1 BDSG, Art. 83 Absatz 5 lit b DSGVO für 3 Jahre. Dieser Zeitraum kann sich verlängern, sofern sich die gesetzliche Verjährungsfrist durch Verjährungsunterbrechungen verlängert (z.B. im Rahmen von Anfragen der Aufsichtsbehörden).",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "5. Werden Daten in ein Drittland oder an eine internationale Organisation übermittelt?",
                style: agreementSubHeader,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Eine Datenübermittlung in Drittstaaten (Staaten außerhalb der Europäischen Union – EU) findet nicht statt.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "6. Welche Datenschutzrechte habe ich?",
                style: agreementSubHeader,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Jede betroffene Person hat \n\n•	das Recht auf Auskunft nach Art. 15 DSGVO (d.h. Sie haben das Recht, jederzeit Auskunft über Ihre von uns gespeicherten personenbezogenen Daten zu verlangen), \n\n•	das Recht auf Berichtigung nach Art. 16 DSGVO (d.h. für den Fall, dass Ihre personenbezogenen Daten unrichtig oder unvollständig sind, können Sie die Berichtigung dieser Daten verlangen), \n\n•	das Recht auf Löschung nach Art. 17 DSGVO und das Recht auf Einschränkung der Verarbeitung nach Art. 18 DSGVO (d.h. Sie haben ggf. das Recht, die Löschung bzw. Einschränkung der Verarbeitung Ihrer personenbezogenen Daten zu verlangen, wenn z.B. für eine solche Verarbeitung kein legitimer Geschäftszweck mehr besteht und gesetzliche Aufbewahrungspflichten die weitere Speicherung nicht erfordern), \n\n•	das Recht auf Datenübertragbarkeit aus Art. 20 DSGVO (d.h. Sie haben ggf. das Recht, die Sie betreffenden personenbezogenen Daten, die Sie uns bereitgestellt haben, in einem strukturierten, gängigen und maschinenlesbaren Format zu erhalten und diese Daten einem anderen Verantwortlichen ohne Behinderung zu übermitteln).\n\nFerner können Sie Einwilligungen, grundsätzlich mit Wirkung für die Zukunft, widerrufen. \n\nDarüber hinaus besteht ein Beschwerderecht bei einer Datenschutzaufsichtsbehörde (Art. 77 DSGVO i.V.m. § 19 BDSG). Die für Sie zuständige Aufsichtsbehörde finden Sie unter https://www.bfdi.bund.de/DE/Infothek/Anschriften_Links/anschriften_links-node.html\n\nZusätzlich möchten wir auf Ihr Widerspruchsrecht nach Art. 21 DSGVO hinweisen:",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Information über Ihr Widerspruchsrecht nach Art. 21 DSGVO",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Sie haben das Recht, aus Gründen, die sich aus Ihrer besonderen Situation ergeben, jederzeit gegen die Verarbeitung Sie betreffender personenbezogener Daten, die aufgrund von Art. 6 Abs. 1 Satz 1 lit. e) DSGVO (Datenverarbeitung im öffentlichen Interesse) und Artikel 6 Abs. 1 Satz 1 lit. f) der DSGVO (Datenverarbeitung auf der Grundlage einer Interessenabwägung) erfolgt, Widerspruch einzulegen; dies gilt auch für ein auf diese Bestimmung gestütztes Profiling im Sinne von Artikel 4 Nr. 4 DSGVO.  \n\nLegen Sie Widerspruch ein, werden wir Ihre personenbezogenen Daten nicht mehr verarbeiten, es sei denn, wir können zwingende schutzwürdige Gründe für die Verarbeitung nachweisen, die Ihre Interessen, Rechte und Freiheiten überwiegen, oder die Verarbeitung dient der Geltendmachung, Ausübung oder Verteidigung von Rechtsansprüchen.\n\nIn Einzelfällen verarbeiten wir Ihre personenbezogenen Daten, um Direktwerbung zu betreiben. Sie haben das Recht, jederzeit Widerspruch gegen die Verarbeitung Sie betreffender personenbezogener Daten zum Zwecke derartiger Werbung einzulegen; dies gilt auch für das Profiling, soweit es mit solcher Direktwerbung in Verbindung steht. Widersprechen Sie der Verarbeitung für Zwecke der Direktwerbung, so werden wir Ihre personenbezogenen Daten nicht mehr für diese Zwecke verarbeiten. \n\nDer Widerspruch kann formfrei erfolgen und es fallen keine anderen als die Übermittlungskosten nach den Basistarifen an. \n\nMöchten Sie von Ihrem Widerspruchsrecht Gebrauch machen, genügt eine formlose Mitteilung, z.B. an die oben genannten Kontaktdaten.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "7. Inwieweit gibt es eine automatisierte Entscheidungsfindung im Einzelfall einschließlich Profiling?",
                style: agreementSubHeader,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Im Rahmen des Zugriffs auf unsere App bzw. im Rahmen der Kontaktaufnahme per Formular oder E-Mail nutzen wir grundsätzlich keine vollautomatisierte automatische Entscheidungsfindung gemäß Artikel 22 DSGVO. Sollten wir diese Verfahren in Einzelfällen einsetzen, werden wir Sie hierüber gesondert informieren, sofern dies gesetzlich vorgegeben ist. Wir verarbeiten Ihre Daten nicht automatisiert mit dem Ziel, bestimmte persönliche Aspekte zu bewerten (Profiling). ",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "8. Besteht für mich eine Pflicht zur Bereitstellung von Daten? ",
                style: agreementSubHeader,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Im Rahmen unserer App müssen Sie diejenigen personenbezogenen Daten bereitstellen, die für die Nutzung unserer App technisch bzw. aus IT-Sicherheitsgründen erforderlich sind. Sofern Sie diese Daten nicht bereitstellen, können Sie unsere App nicht nutzen.\b\nIm Rahmen der Kontaktaufnahme per Formular oder E-Mail müssen Sie nur diejenigen personenbezogenen Daten bereitstellen, die für die Bearbeitung Ihrer Anfrage erforderlich sind. Andernfalls können wir Ihre Anfrage nicht bearbeiten.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
