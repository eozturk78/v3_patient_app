import 'dart:convert';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/question-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:patient_app/shared/toast.dart';
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
  String? endNode;
  List<dynamic> elements = [];
  List<dynamic> buttons = [];
  List<dynamic> outPuts = [];
  bool isLast = false;

  int inputType = 0; // 10 input list, 20 multiple, 30 yes/no

  @override
  void initState() {
    super.initState();
    getQuestionnaireResults();
  }

  getQuestionnaireResults() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var qid = pref.getString('questionnaireId');

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
              questions = value['nodes'];
              var startNode = value['startNode'];
              endNode = value['endNode'];
              findQuestionaire(startNode);
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

  clearAll() {
    try {
      _controllers.clear();
      inputList.clear();
      buttons.clear();
      elements.clear();
      choices.clear();
      info = "";
      questionText = "";
      isMultiChoice = false;
      _groupValue = null;
    } catch (err) {}
  }

  getResult() async {
    clearAll();
    info = "";
    setState(() {
      questionText = question['text'] ?? question['question'];
      deviceNode = question['deviceNode'];
      if (question['elements'] != null && question['elements'].length > 0) {
        try {
          var elems = question['elements'];
          for (var element in elems) {
            if (element['TextViewElement'] != null) {
              elements.add(element['TextViewElement']);
            } else if (element['ButtonElement'] != null) {
              var p = {
                "next": element['ButtonElement']['next'],
                "text": element['ButtonElement']['text'],
              };
              buttons.add(p);
            } else if (element['TwoButtonElement'] != null) {
              var p = {
                "next": element['TwoButtonElement']['leftNext'],
                "text": element['TwoButtonElement']['leftText'],
              };
              buttons.add(p);
              p = {
                "next": element['TwoButtonElement']['rightNext'],
                "text": element['TwoButtonElement']['rightText'],
              };
              buttons.add(p);
            } else if (element['EditTextElement'] != null) {
              var outputVar = element['EditTextElement']['outputVariable'];
              setState(() {
                _controllers.add(TextEditingController());
              });
              var params = {
                'name': outputVar['name'],
                'type': outputVar['type'],
                "title": ""
              };
              inputList.add(params);
              print(inputList);
            }
          }
        } catch (err) {}
      } else {
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
            var existKeyCount =
                (question['existsKeys'] as List<dynamic>).length;
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
                  if (question[key]['type'] == 'Integer' ||
                      question[key]['type'] == 'String' ||
                      question[key]['type'] == 'Float' ||
                      question[key]['type'] == 'Object[]') {
                    _controllers.add(TextEditingController());
                    inputList.add(question[key]);
                    inputList[inputList.length - 1]['title'] =
                        question['existsKeys'][i];
                  }
                } catch (err) {
                  inputList.removeAt(inputList.length - 1);
                }
              }
            }
          } else {
            if (question['displayTextString'] != null)
              questionText = question['displayTextString'];
          }
        }
        var p = {'next': question['next'], 'text': 'SENDEN'};
        buttons.add(p);
      }
    });
  }

  findQuestionaire(String next) {
    question = questions.where((x) => x['nodeName'] == next).first;
    if (question['deviceNode'] == 'EndNode') {
      setState(() {
        isLast = true;
      });
      clearAll();
    } else {
      if (question['variable'] == null) getResult();
      if (question['variable'] != null) {
        var p = {
          'name': question['variable']['name'],
          'type': question['variable']['type'],
          'value': question['expression']['value']
        };
        outPuts.add(p);
        findQuestionaire(question['next']);
      }
    }
  }

  prepareOutputs() {
    print(question);

    if (inputList.isNotEmpty) {
      for (var i = 0; i < inputList.length; i++) {
        var p = {
          'name': inputList[i]['name'],
          'type': inputList[i]['type'],
          'value': _controllers[i].text
        };
        outPuts.add(p);
      }
    } else if (isMultiChoice && question['origin'] != null) {
      var p = {
        'name': question['origin']['name'],
        'type': question['origin']['type'],
        'value': _groupValue
      };
      outPuts.add(p);
    }
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
                          if (isLast) Text("Möchten Sie Ergebnisse senden?"),
                          Text(
                            questionText ?? "",
                            style: labelText,
                          ),
                          if (elements != null)
                            for (int i = 0; i < elements!.length; i++)
                              Column(
                                children: [
                                  Text(
                                    elements[i]['text'],
                                    style: i == 0 ? labelText : null,
                                  )
                                ],
                              ),
                          SizedBox(
                            height: 15,
                          ),
                          if (deviceNode == 'EcgDeviceNode')
                            Text("Please connect to device")
                          else if (deviceNode == 'BloodSugarManualDeviceNode')
                            Column(
                              children: [
                                TextFormField(
                                  obscureText: false,
                                  keyboardType: TextInputType.number,
                                ),
                                RadioListTile(
                                  value: 1,
                                  groupValue: _groupValue,
                                  onChanged: (newValue) =>
                                      setState(() => _groupValue = newValue!),
                                  title: Text("Vor dem Essen"),
                                ),
                                RadioListTile(
                                  value: 2,
                                  groupValue: _groupValue,
                                  onChanged: (newValue) =>
                                      setState(() => _groupValue = newValue!),
                                  title: Text("Nach dem Essen"),
                                ),
                                RadioListTile(
                                  value: 3,
                                  groupValue: _groupValue,
                                  onChanged: (newValue) =>
                                      setState(() => _groupValue = newValue!),
                                  title: Text("Fasten"),
                                ),
                                RadioListTile(
                                  value: 4,
                                  groupValue: _groupValue,
                                  onChanged: (newValue) =>
                                      setState(() => _groupValue = newValue!),
                                  title: Text("Keine der oben genannten"),
                                )
                              ],
                            )
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
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      inputList[i]['title'],
                                      style: labelText,
                                    ),
                                    TextFormField(
                                      controller: _controllers[i],
                                      obscureText: false,
                                      keyboardType:
                                          inputList[i]['title'] != "String"
                                              ? TextInputType.number
                                              : null,
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
          mainAxisAlignment: buttons.length > 1
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var item in buttons)
              SizedBox(
                  width: 150,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: mainButtonColor,
                      ),
                      onPressed: () async {
                        prepareOutputs();
                        if (item['next'] == endNode) {
                          print(outPuts);
                          setState(() {
                            isLast = true;
                          });
                          clearAll();
                        } else {
                          if (item['next'] != null)
                            findQuestionaire(item['next']);
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [Icon(Icons.check), Text(item['text'])],
                      ))),
          ],
        ),
      ),
    );
  }
}
