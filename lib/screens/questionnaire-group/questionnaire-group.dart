import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/model/questionnaire-group.dart';
import 'package:patient_app/screens/main-menu/main-menu.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../apis/apis.dart';
import '../../shared/shared.dart';

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
  Shared sh = Shared();

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
              sh.redirectPatient(err, context);
              isStarted = false;
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalObjectKey<ExpandableFabState>(context);
    String title = "MP";
    Shared sh = new Shared();
    return Scaffold(
      appBar:
          leadingSubpage(sh.getLanguageResource("daily_measurements"), context),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width *
                ResponsiveValue(
                  context,
                  defaultValue: 1,
                  conditionalValues: [
                    Condition.largerThan(
                      //Tablet
                      name: MOBILE,
                      value: 0.7,
                    ),
                  ],
                ).value!,
            child: isStarted
                ? Center(
                    child: CircularProgressIndicator(
                      color: mainButtonColor,
                    ),
                  )
                : questionnaireGroups.isEmpty
                    ? Center(child: sh.getLanguageResource("no_data_found"))
                    : Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            verticalDirection: VerticalDirection.down,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              for (var item in questionnaireGroups)
                                Column(
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        hideNavBar = true;
                                        SharedPreferences pref =
                                            await SharedPreferences
                                                .getInstance();
                                        pref.setString('questionnaireId',
                                            item.questionnaireId);
                                        pref.setString('questionnaireName',
                                            item.nameShownToPatient);
                                        Navigator.of(context)
                                            .pushNamed('/questionnaire-result');
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              item.nameShownToPatient ??
                                                  item.name,
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.black,
                                                  fontSize: ResponsiveValue(
                                                    context,
                                                    defaultValue: 12.0,
                                                    conditionalValues: [
                                                      Condition.largerThan(
                                                        //Tablet
                                                        name: MOBILE,
                                                        value: 20.0,
                                                      ),
                                                    ],
                                                  ).value!),
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: mainButtonColor,
                                            size: 20,
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      height: 40,
                                    )
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
