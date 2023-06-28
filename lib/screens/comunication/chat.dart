import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/message-list-container.dart';
import 'package:patient_app/screens/shared/shared.dart';

import '../shared/bottom-menu.dart';
import '../shared/message-text-bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class Message {
  String? image;
  String text;
  String dateTime;
  String senderTitle;
  int senderType;
  Message(
      {required this.text,
      required this.senderType,
      required this.senderTitle,
      required this.dateTime,
      this.image});
}

class _ChatPageState extends State<ChatPage> {
  List<Message> listMessages = [
    Message(
        text:
            "Herzlich willkommen in unserer iMedCom- Applikation !\n \n   Wir freuen uns, Sie als Patienten in unserer innovativen medizinischen Einrichtung begrüßen zu dürfen. Bei uns steht Ihre Gesundheit und Ihr Wohlbefinden an erster Stelle, und wir sind bestrebt, Ihnen die bestmögliche medizinische Betreuung zu bieten, ohne dass Sie Ihr Zuhause verlassen müssen.\n \n Um Ihnen den Behandlungsprozess so bequem wie möglich zu gestalten, haben wir ein hochmodernes System entwickelt, das es Ihnen ermöglicht, Ihren Medikamentenplan direkt von uns zu erhalten. Unsere elektronische Plattform sendet Ihre Medikamentenpläne direkt an Sie, damit Sie stets über Ihre aktuellen Arzneimittel informiert sind.\n \n Des Weiteren werden Sie täglich an das Ausfüllen unserer Fragebögen erinnert. Diese Bögen helfen uns, Ihren Gesundheitszustand genau zu überwachen und individuell auf Ihre Bedürfnisse einzugehen. Durch Ihre ehrlichen Antworten ermöglichen Sie es , die bestmögliche Behandlung für Sie zu gewährleisten.\n \n Wenn Sie während Ihrer Behandlung Fragen haben oder weitere Informationen benötigen, stehen Ihnen unsere Schwestern und/oder Ärzte rund um die Uhr zur Verfügung. Sie können jederzeit eine Nachricht über unser sicheres Kommunikationssystem senden und unser qualifiziertes Team wird Ihnen so schnell wie möglich antworten.\n \n Wir sind hier, um Ihnen zu helfen und Ihre Anliegen zu klären.\n \n Darüber hinaus möchten wir Ihnen mitteilen, dass in der virtuellen Klinik eine umfangreiche Bibliothek mit Informationen rund um Ihr spezifisches Krankheitsbild zur Verfügung steht. Hier finden Sie wertvolle Ressourcen, Fachartikel, Leitlinien und weitere informative Inhalte, die Ihnen helfen, Ihr Krankheitsbild besser zu verstehen. Unser Ziel ist es, Ihnen das nötige Wissen zur Verfügung zu stellen, um gemeinsam mit Ihnen die bestmöglichen Entscheidungen bezüglich Ihrer Gesundheit zu treffen.\n \n Außerdem haben wir ein integriertes Videokonferenz-Tool, das es Ihnen ermöglicht, Termine mit unseren Fachleuten bequem von zu Hause aus wahrzunehmen. Diese virtuellen Besprechungen ermöglichen es Ihnen, von Expertenrat und persönlicher Betreuung zu profitieren, ohne dass Sie physisch in unsere Klinik kommen müssen. Ihr Wohlbefinden liegt uns am Herzen, und wir wollen sicherstellen, dass Sie jederzeit Zugang zu unseren medizinischen Fachkräften haben.\n \n Nochmals herzlich willkommen in unserer virtuellen Klinik! Wir sind stolz darauf, Ihnen eine erstklassige Versorgung anzubieten, die modern, bequem und effektiv ist. Zögern Sie nicht, uns bei Fragen, Anliegen oder für Unterstützung zu kontaktieren.\n \n Ihr Team der virtuellen Klinik",
        senderType: 10,
        senderTitle: 'David Brockmann',
        dateTime: '23.06.2023 13:27'),
    Message(
        text:
            "Vielen Dank für die Begrüßung. Ich bin nun zuhause und werde mich durch die App klicken.",
        senderType: 20,
        senderTitle: "Max Mustermann",
        dateTime: '23.06.2023 13:28'),
    Message(
        text:
            "Könnten Sie mir bei Gelegenheit den neuen Medikamentenplan von Dr. Müller zukommen lassen ?",
        senderType: 20,
        senderTitle: "Max Mustermann",
        dateTime: '23.06.2023 13:29'),
    Message(
        text:
            "Sehr geehrter Patient, wir halten zeitnah Rücksprache mit dem Doktor und senden Ihnen den Med.-Plan zu . Diesen können Sie dann als Bilddatei oder auch als PDF herunterladen und ggf. auf Wunsch auch ausdrucken.",
        senderType: 10,
        senderTitle: 'David Brockmann',
        dateTime: '23.06.2023 13:31'),
    Message(
        text:
            "Für Sie wurde ein neuer Medikamentenplan erstellt. Diesen können Sie über den nachfolgenden Link abrufen:https://imc-app.de/pdf/1687516298951",
        senderType: 10,
        senderTitle: 'David Brockmann',
        image: "assets/images/message-1.png",
        dateTime: '23.06.2023 13:31'),
    Message(
        text:
            "Dies ist der alte Medikamtenplan für Ihre Unterlagen. Die überarbeitete bzw. veränderte Version senden wir im Anschluss.",
        senderType: 10,
        senderTitle: 'David Brockmann',
        dateTime: '23.06.2023 13:31'),
    Message(
        text:
            "Für Sie wurde ein neuer Medikamentenplan erstellt. Diesen können Sie über den nachfolgenden Link abrufen:https://imc-app.de/pdf/1687519862205",
        senderType: 10,
        senderTitle: 'David Brockmann',
        image: "assets/images/message-2.png",
        dateTime: '23.06.2023 14:43'),
    Message(
        text:
            "Hier befindet sich ihr neuer Medimamentenplan, inklusive der Erklärungen welches Medikament gegen welche Symptome bzw. bei welcher Krankheit eingenommen werden soll.\n \n Bei Rückfragen stehen wir Ihnen jederzeit zur Verfügung.\n \nWir wünschen ein schönes Wochenende !",
        senderType: 10,
        senderTitle: 'David Brockmann',
        dateTime: '23.06.2023 14:43'),
    Message(
        text:
            "Vielen Dank ! Ich wünsche Ihnen auch ein schönes Wochenende und danke für Ihre Mühe",
        senderType: 20,
        senderTitle: "Max Mustermann",
        dateTime: '23.06.2023 14:45')
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Nachrichten!', context),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.75,
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: listMessages?.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return CustomMessageTextBubble(
                            listMessages[index].image,
                            listMessages[index].text,
                            listMessages[index].dateTime,
                            listMessages[index].senderType,
                            listMessages[index].senderTitle);
                      }),
                ),
              ),
              TextFormField(
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Message',
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min, // added line
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.image_outlined),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigatorBar(1),
    );
  }
}
