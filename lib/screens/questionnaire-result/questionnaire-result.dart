import 'dart:convert';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/question-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../shared/document-box.dart';

class QuestionnaireResultPage extends StatefulWidget {
  const QuestionnaireResultPage({super.key});

  @override
  State<QuestionnaireResultPage> createState() =>
      _QuestionnaireResultPageState();
}

class _QuestionnaireResultPageState extends State<QuestionnaireResultPage> {
  Apis apis = Apis();
  bool isStarted = true;
  PDFDocument? document;
  String? title;
  String? imageUrl;
  bool isPdf = false;
  dynamic questions = [];
  @override
  void initState() {
    super.initState();
    getQuestionnaireResults();
  }

  getQuestionnaireResults() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var qid = pref.getString('questionnaireId');
    print(qid);
    pref.remove("questionnaireId");
    setState(() {
      title = pref.getString('questionnaireName');
    });
    pref.remove("questionnaireName");
    isStarted = true;
    Apis apis = Apis();
    apis.getQuestionnaireResults(qid!).then(
          (value) => {
            setState(() {
              isStarted = false;
              questions = value;
            })
          },
          onError: (err) => setState(
            () {
              isStarted = false;
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage(title!, context),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: isStarted
              ? CircularProgressIndicator(
                  color: mainButtonColor,
                )
              : questions.isEmpty
                  ? Center(child: Text("no data found"))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          for (dynamic item in questions)
                            if (item['question'] != null ||
                                item['text'] != null)
                              GestureDetector(
                                  onTap: () async {
                                    SharedPreferences pref =
                                        await SharedPreferences.getInstance();
                                    pref.setString(
                                        'objectResponse', jsonEncode(item));
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context)
                                        .pushNamed('/send-result');
                                  },
                                  child: QuestionBox(item['question'] != null
                                      ? item['question']
                                      : item['text'])),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
