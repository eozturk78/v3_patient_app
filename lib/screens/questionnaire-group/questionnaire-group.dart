import 'dart:async';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/model/questionnaire-group.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../apis/apis.dart';
import '../../model/file.dart';
import '../shared/bottom-menu.dart';
import '../shared/document-box.dart';
import '../shared/library-box.dart';
import '../shared/medication-plan-box.dart';
import '../shared/profile-menu.dart';

class QuestionnaireGroupPage extends StatefulWidget {
  const QuestionnaireGroupPage({super.key});

  @override
  State<QuestionnaireGroupPage> createState() => _QuestionnaireGroupPageState();
}

class _QuestionnaireGroupPageState extends State<QuestionnaireGroupPage> {
  Apis apis = Apis();
  List<QuestionnaireGroup> questionnaireGroups = [];
  bool isStarted = true;
  PDFDocument? document;
  String? imageUrl;
  bool isPdf = false;

  @override
  void initState() {
    super.initState();
    getFiles();
  }

  getFiles() async {
    isStarted = true;
    Apis apis = Apis();
    apis.getQuestionnaireGroups().then(
          (value) => {
            setState(() {
              isStarted = false;
              questionnaireGroups = (value as List)
                  .map((e) => QuestionnaireGroup.fromJson(e))
                  .toList();
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
    final key = GlobalObjectKey<ExpandableFabState>(context);
    String title = "MP";

    return Scaffold(
      appBar: leadingSubpage('Grafische Darstellungen', context),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: isStarted
              ? CircularProgressIndicator(
                  color: mainButtonColor,
                )
              : questionnaireGroups.isEmpty
                  ? Center(child: Text("no data found"))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          for (var item in questionnaireGroups)
                            GestureDetector(
                                onTap: () async {
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  pref.setString(
                                      'questionnaireId', item.questionnaireId);
                                  pref.setString(
                                      'questionnaireName', item.name);
                                  Navigator.of(context)
                                      .pushNamed('/questionnaire-result');
                                },
                                child: CustomDocumentBox(
                                    Icons.file_copy_rounded,
                                    item.nameShownToPatient ?? item.name,
                                    null)),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
