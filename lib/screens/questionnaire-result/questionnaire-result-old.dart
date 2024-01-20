import 'dart:convert';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/question-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../../shared/enums.dart';
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
  String? questionText;
  dynamic questions = [];
  dynamic question = {};
  List<dynamic> inputList = [];
  List<dynamic> choices = [];
  bool isMultiChoice = false;
  final _controllers = [];
  Enums enumCls = Enums();
  int wizardIndex = 0;
  dynamic _groupValue = "";
  String deviceNode = "";
  String? info;
  @override
  void initState() {
    super.initState();
    getQuestionnaireResults();
  }

  getQuestionnaireResults() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var qid = pref.getString('questionnaireId');
    print(qid);
    setState(() {
      title = pref.getString('questionnaireName')!;
    });
    pref.remove("questionnaireName");
    isStarted = true;
    Apis apis = Apis();
    apis.getQuestionnaireResults(qid!).then(
          (value) => {
            setState(() {
              isStarted = false;
              questions = value;
              (questions as List)
                  .sort((a, b) => a['nodeName'].compareTo(b['nodeName']));

              getResult();
            })
          },
          onError: (err) => setState(
            () {
              isStarted = false;
            },
          ),
        );
  }

  getResult() async {
    _controllers.clear();
    inputList.clear();
    question = questions[wizardIndex];
    info = "";
    setState(() {
      questionText = question['text'] ?? question['question'];
      deviceNode = question['deviceNode'];
      if (question['elements'] != null && question['elements'].length > 0) {
        try {
          questionText = question['elements'][0]['TextViewElement']['text'];

          _controllers.add(TextEditingController());
          if (question['elements'][1]['EditTextElement'] != null) {
            inputList.add(
                question['elements'][1]['EditTextElement']['outputVariable']);
            inputList[inputList.length - 1]['title'] = "";
          } else {
            info = question['elements'][1]['TextViewElement']['text'];
          }
        } catch (err) {}
      }
      /*find input count*/
      isMultiChoice =
          (question['existsKeys'] as List<dynamic>).indexOf('answer') > -1
              ? true
              : false;
      if (isMultiChoice) {
        choices = question['answer']['choices'];
      } else {
        var originIndex =
            (question['existsKeys'] as List<dynamic>).indexOf('origin');
        if (originIndex > -1) {
          var existKeyCount = (question['existsKeys'] as List<dynamic>).length;
          for (var i = originIndex + 1; i < existKeyCount; i++) {
            var key = question['existsKeys'][i];
            var enumObj = enumCls.enumDeviceNodeParserTypes
                        .where((element) => element['typeName'] == key)
                        .length >
                    0
                ? enumCls.enumDeviceNodeParserTypes
                    .where((element) => element['typeName'] == key)
                    .first
                : null;
            if (enumObj != null) {
              isMultiChoice = true;
              choices = enumObj['values'] as List<dynamic>;
            } else {
              try {
                _controllers.add(TextEditingController());
                inputList.add(question[key]);

                inputList[inputList.length - 1]['title'] =
                    question['existsKeys'][i];
              } catch (err) {
                inputList.removeAt(inputList.length - 1);
              }
            }
          }
        }
      }
    });
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
                  ? Center(child: Text("Keine Daten gefunden"))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            questionText ?? "",
                            style: labelText,
                          ),
                          if (info != null) Text(info!),
                          SizedBox(
                            height: 15,
                          ),
                          if (deviceNode == 'EcgDeviceNode')
                            Text(" Bitte schließen Sie Ihr EKG - Gerät an")
                          else if (isMultiChoice == true)
                            Column(
                              children: [
                                for (var item in choices)
                                  RadioListTile(
                                    value: item['value'],
                                    groupValue: _groupValue,
                                    onChanged: (newValue) =>
                                        setState(() => _groupValue = newValue!),
                                    title: Text(item['text']),
                                  )
                              ],
                            )
                          else
                            for (var i = 0; i < inputList.length; i++)
                              if (inputList[i] != null &&
                                  inputList[i]['type'] != null &&
                                  (inputList[i]['type'] == 'Integer' ||
                                      inputList[i]['type'] == 'String' ||
                                      inputList[i]['type'] == 'Float'))
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        inputList[i]['title'],
                                        style: labelText,
                                      ),
                                      TextFormField(
                                        controller: _controllers[i],
                                        obscureText: false,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Divider(
                                          color: const Color.fromARGB(
                                              255, 134, 134, 134)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                )
                              else if (inputList[i]['type'] == 'Boolean')
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {}, child: Text("Yes")),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      child: Text("No"),
                                      style: ElevatedButton.styleFrom(
                                          primary: const Color.fromARGB(
                                              255, 158, 158, 158)),
                                    )
                                  ],
                                ),
                        ],
                      ),
                    ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (wizardIndex > 0)
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                  ),
                  onPressed: () async {
                    setState(() {
                      wizardIndex--;
                    });
                    getResult();
                  },
                  child: Text("Back"),
                ),
              ),
            SizedBox(width: 8),
            if (wizardIndex < questions?.length - 1)
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: mainButtonColor,
                  ),
                  onPressed: () async {
                    setState(() {
                      wizardIndex++;
                    });
                    getResult();
                  },
                  child: Text("Next"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
