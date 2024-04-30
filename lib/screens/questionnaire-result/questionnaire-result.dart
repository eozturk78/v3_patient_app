import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/model/scale-size.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:photo_view/photo_view.dart';
import '../../apis/apis.dart';
import '../../shared/enums.dart';
import '../../shared/shared.dart';

class QuestionnaireResultPage extends StatefulWidget {
  const QuestionnaireResultPage({super.key});

  @override
  State<QuestionnaireResultPage> createState() =>
      _QuestionnaireResultPageState();
}

class _QuestionnaireResultPageState extends State<QuestionnaireResultPage> {
  TextEditingController controllerBloodSugar = TextEditingController();
  Apis apis = Apis();
  Shared sh = Shared();
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
  FocusNode focusNotToFirst = FocusNode();
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
  bool isSendEP = false;
  int inputType = 0; // 10 input list, 20 multiple, 30 yes/no
  late String _qid;
  bool isValueValid = false;
  dynamic _next;
  String? multiChoiseName;
  String? multiChoiseType;
  List<String> oldSteps = [];
  dynamic _helpText;
  String? _helpImageStr;
  bool loaderImage = false;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    getQuestionnaireResults();
    sh.openPopUp(context, 'questionnaire-result');
  }

  getQuestionnaireResults() async {
    for (var i = 0; i < 101; i++) {
      values.add(i / 10);
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    var qid = pref.getString('questionnaireId');
    _qid = qid!;
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
              sh.redirectPatient(err, context);
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
      // choices.clear();
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
      multiChoiseName = null;
      multiChoiseType = null;
      if (question['elements'] != null && question['elements'].length > 0) {
        try {
          var elems = question['elements'];
          for (var element in elems) {
            if (element['TextViewElement'] != null &&
                element['TextViewElement']['text'] != null) {
              element['TextViewElement']['text'] =
                  element['TextViewElement']['text'].replaceAll('\"', '"');
              element['TextViewElement']['text'] = element['TextViewElement']
                      ['text']
                  .replaceAll('font-feature-settings: normal;', '');
            }

            if (element['TextViewElement'] != null) {
              elements.add(element['TextViewElement']);
            } else if (element['ButtonElement'] != null) {
              var p = {
                "next": element['ButtonElement']['next'],
                "text": element['ButtonElement']['text'],
                "isNo": false
              };
              buttons.add(p);
            } else if (element['TwoButtonElement'] != null) {
              var p = {
                "next": element['TwoButtonElement']['leftNext'],
                "text": element['TwoButtonElement']['leftText'],
                "isNo": true
              };
              buttons.add(p);
              p = {
                "next": element['TwoButtonElement']['rightNext'],
                "text": element['TwoButtonElement']['rightText'],
                "isNo": false
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
            } else if (element['HelpTextElement'] != null) {
              _helpText =
                  element['HelpTextElement']['text'].replaceAll('\"', '"');
              _helpText =
                  _helpText.replaceAll('font-feature-settings: normal;', '');

              if (element['HelpTextElement']['image'] != null) {
                _helpImageStr = element['HelpTextElement']['image'];
              }
            }
          }
        } catch (err) {}
      } else {
        isMultiChoice =
            (question['existsKeys'] as List<dynamic>).indexOf('answer') > -1
                ? true
                : false;
        if (isMultiChoice) {
          multiChoiseName = question['answer']['name'];
          multiChoiseType = question['answer']['type'];
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
                  if ((question[key]['type'] == 'Integer' ||
                          question[key]['type'] == 'String' ||
                          question[key]['type'] == 'Float') &&
                      !question[key]['name']
                          .toString()
                          .contains('MEAN_ARTERIAL_PRESSURE')) {
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
        var p = {'next': question['next'], 'text': "next", 'isNo': false};
        buttons.add(p);
      }
    });
  }

  findQuestionaire(String next) {
    if (oldSteps.where((element) => element == next).length == 0)
      oldSteps.add(next);

    _helpImageStr = null;
    _helpText = null;
    question = questions.where((x) => x['nodeName'] == next).first;
    if (question['deviceNode'] == 'EndNode') {
      setState(() {
        isLast = true;
      });
      clearAll();
    } else if (question['deviceNode'] == 'MultipleChoiceSummationNode') {
      var intervals = question['intervals'][0];
      findQuestionaire(intervals['next']);
    } else if (question['deviceNode'] == 'DecisionNode') {
      findQuestionaire(question['next']);
    } else if (question['variable'] == null)
      getResult();
    else if (question['variable'] != null) {
      if (!question['variable']['name'].toString().contains("ECG")) {
        var p = {
          'name': question['variable']['name'],
          'type': question['variable']['type'],
          'value': question['expression']['value']
        };
        removeOutputParameter(p['name']);
        outPuts.add(p);
      }
      findQuestionaire(question['next']);
    }
  }

  findQuestionaireBack(String next) {
    if (oldSteps.where((element) => element == next).length == 0)
      oldSteps.add(next);

    setState(() {
      _helpImageStr = null;
      _helpText = null;
    });
    question = questions.where((x) => x['nodeName'] == next).first;
    if (question['deviceNode'] == 'EndNode') {
      setState(() {
        isLast = true;
      });
      clearAll();
    } else if (question['deviceNode'] == 'MultipleChoiceSummationNode') {
      stepPage--;
      findQuestionaireBack(oldSteps[stepPage]);
    } else if (question['deviceNode'] == 'DecisionNode') {
      stepPage--;
      findQuestionaireBack(oldSteps[stepPage]);
    } else if (question['variable'] == null)
      getResult();
    else if (question['variable'] != null) {
      stepPage--;
      findQuestionaireBack(oldSteps[stepPage]);
    }
  }

  int stepPage = 0;
  prepareOutputs() {
    if (question['deviceNode'] == 'PainScaleManualDeviceNode') {
      var p = {
        'name': question['painScale']['name'],
        'type': question['painScale']['type'],
        'value': values[selectedIndex]
      };
      removeOutputParameter(p['name']);
      outPuts.add(p);
    } else if (question['deviceNode'] == 'BloodSugarManualDeviceNode') {
      var measurements = null;
      var dt = DateTime.now().toUtc().toString().replaceAll(" ", "T"); /**/
      if (_groupValue == 0) {
        measurements = [
          {
            'result': double.parse(controllerBloodSugar.text),
            'isBeforeMeal': true,
            "timeOfMeasurement": dt
          }
        ];
      } else if (_groupValue == 1) {
        measurements = [
          {
            'result': double.parse(controllerBloodSugar.text),
            'isAfterMeal': true,
            "timeOfMeasurement": dt
          }
        ];
      } else if (_groupValue == 2) {
        measurements = [
          {
            'result': double.parse(controllerBloodSugar.text),
            'isFasting': true,
            "timeOfMeasurement": dt
          }
        ];
      } else {
        measurements = [
          {
            'result': double.parse(controllerBloodSugar.text),
            "timeOfMeasurement": dt
          }
        ];
      }
      var p = {
        'name': question['bloodSugarMeasurements']['name'],
        'type': 'Object',
        'value': {'measurements': measurements, "transferTime": dt}
      };
      removeOutputParameter(p['name']);
      outPuts.add(p);
      //stepPage++;
    } else if (inputList.isNotEmpty) {
      for (var i = 0; i < inputList.length; i++) {
        var value = _controllers[i].text;

        if (inputList[i]['type'] == "Integer") value = int.parse(value);
        if (inputList[i]['type'] == "Float") {
          value = value.toString().replaceAll(",", ".");
          value = double.parse(value);
        }
        var p = {
          'name': inputList[i]['name'],
          'type': inputList[i]['type'],
          'value': value
        };
        removeOutputParameter(p['name']);
        outPuts.add(p);
      }
      stepPage++;
    } else if (isMultiChoice && question['origin'] != null) {
      var name = question['origin']['name'].toString();

      if (name.contains("#")) name = name.substring(0, name.indexOf("#"));

      var p = {
        'name': name, //question['origin']['name'],
        'type': question['origin']['type'],
        'value': _groupValue
      };
      removeOutputParameter(p['name']);
      outPuts.add(p);
      // stepPage++;
    } else if (isMultiChoice && multiChoiseType != null) {
      var p = {
        'name': multiChoiseName,
        'type': multiChoiseType,
        'value': _groupValue
      };
      removeOutputParameter(p['name']);
      outPuts.add(p);
      //  stepPage++;
    }

    stepPage++;
  }

  removeOutputParameter(String name) {
    var nameIndex = outPuts.indexWhere((element) => element['name'] == name);
    if (nameIndex > -1) outPuts.removeAt(nameIndex);
  }

  sendValues() {
    setState(() {
      isSendEP = true;
    });
    apis.setMeasurementValues(outPuts, _qid).then((resp) {
      setState(() {
        isSendEP = false;
      });

      showDialog(
        context: context,
        builder: (context) => savedSuccessFully(context),
      ).then((value) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/home', ModalRoute.withName("/questionnaire-group"));
      });
    }, onError: (err) {
      setState(() {
        isSendEP = false;
      });
    });
  }

  getChoose(dynamic choise, dynamic value) {
    _groupValue = value;
    _next = choise['next'];
  }

  previousQuestion() {
    isLast = false;
    stepPage--;
    findQuestionaireBack(oldSteps[stepPage]);
  }

  final List<double> values = [];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: stepPage > 0
            ? TextButton(
                onPressed: () => previousQuestion(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.arrow_back_ios, color: mainButtonColor),
                    Text(
                      sh.getLanguageResource("previous_question"),
                      style: TextStyle(
                          color: mainButtonColor,
                          fontSize: ResponsiveValue(
                            context,
                            defaultValue: 10.0,
                            conditionalValues: [
                              Condition.largerThan(
                                //Tablet
                                name: MOBILE,
                                value: 16.0,
                              ),
                            ],
                          ).value!),
                    )
                  ],
                ),
              )
            : null,
        leadingWidth: 120,
        title: FittedBox(
          child: Text(
            title!,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Color.fromARGB(255, 69, 81, 84),
                fontSize: ResponsiveValue(
                  context,
                  defaultValue: 16.0,
                  conditionalValues: [
                    Condition.largerThan(
                      //Tablet
                      name: MOBILE,
                      value: 25.0,
                    ),
                  ],
                ).value!),
            textScaleFactor: ScaleSize.textScaleFactor(context),
          ),
        ),
        shadowColor: null,
        elevation: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: TextButton(
                    child: Text(
                      sh.getLanguageResource("exit_questionnaire"),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => exitQuestionnaire(context),
                      ).then((value) {
                        if (value == 1)
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/questionnaire-group',
                              ModalRoute.withName("/main-menu"));
                      });
                    }),
              ),
            ),
            Center(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 50),
                width: MediaQuery.of(context).size.width *
                    ResponsiveValue(
                      context,
                      defaultValue: 1,
                      conditionalValues: [
                        Condition.largerThan(
                          //Tablet
                          name: MOBILE,
                          value: 0.65,
                        ),
                      ],
                    ).value!,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: isStarted
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.9,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: mainButtonColor,
                                  ),
                                ),
                              )
                            : questions.isEmpty
                                ? Center(
                                    child: Text(
                                    sh.getLanguageResource("no_data_fuond"),
                                  ))
                                : Container(
                                    width: MediaQuery.of(context).size.width *
                                        ResponsiveValue(
                                          context,
                                          defaultValue: 1,
                                          conditionalValues: [
                                            Condition.largerThan(
                                              //Tablet
                                              name: MOBILE,
                                              value: 0.5,
                                            ),
                                          ],
                                        ).value!,
                                    child: Column(
                                      children: [
                                        Text(
                                          questionText ?? "",
                                          style: labelText,
                                        ),
                                        if (elements != null)
                                          for (int i = 0;
                                              i < elements!.length;
                                              i++)
                                            Column(
                                              children: [
                                                Html(data: elements[i]['text'])
                                              ],
                                            ),
                                        if (_helpText != null)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (!loaderImage) {
                                                    setState(() {
                                                      loaderImage = true;
                                                    });
                                                    apis
                                                        .getImageUrl(
                                                            _helpImageStr)
                                                        .then(
                                                      (value) {
                                                        setState(() {
                                                          loaderImage = false;
                                                        });
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              onOpenImage(
                                                                  context,
                                                                  value),
                                                        ).then((value) {});
                                                      },
                                                      onError: (err) =>
                                                          setState(
                                                        () {
                                                          setState(() {
                                                            loaderImage = false;
                                                          });
                                                          sh.redirectPatient(
                                                              err, context);
                                                        },
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: !loaderImage
                                                    ? Icon(Icons.help)
                                                    : Transform.scale(
                                                        scale: 0.5,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                              ),
                                            ],
                                          ),
                                        if (isLast ||
                                            question['deviceNode'] ==
                                                'PainScaleManualDeviceNode' ||
                                            deviceNode == 'EcgDeviceNode' ||
                                            deviceNode == 'EcgDeviceNode' ||
                                            deviceNode ==
                                                'BloodSugarManualDeviceNode' ||
                                            isMultiChoice ||
                                            inputList.length > 0)
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15))),
                                            margin: EdgeInsets.only(top: 20),
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                if (isLast)
                                                  Column(
                                                    children: [
                                                      Text(sh.getLanguageResource(
                                                          "send_measurement_results")),
                                                    ],
                                                  ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                if (question['deviceNode'] ==
                                                    'PainScaleManualDeviceNode')
                                                  Column(
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/vas-score.png",
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 127,
                                                      ),
                                                      Slider(
                                                        value: selectedIndex
                                                            .toDouble(),
                                                        min: 0,
                                                        max: values.length - 1,
                                                        divisions:
                                                            values.length - 1,
                                                        label: values[
                                                                selectedIndex]
                                                            .toString(),
                                                        onChanged:
                                                            (double value) {
                                                          setState(() {
                                                            selectedIndex =
                                                                value.toInt();
                                                          });
                                                        },
                                                      ),
                                                      Center(
                                                        child: Text(
                                                          sh.getLanguageResource(
                                                              "selected_value"),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Center(
                                                        child: Text(values[
                                                                selectedIndex]
                                                            .toString()),
                                                      )
                                                    ],
                                                  )
                                                else if (deviceNode ==
                                                    'EcgDeviceNode')
                                                  Text(
                                                    sh.getLanguageResource(
                                                        "please_connect_ecg"),
                                                  )
                                                else if (deviceNode ==
                                                    'BloodSugarManualDeviceNode')
                                                  Column(
                                                    children: [
                                                      TextFormField(
                                                        controller:
                                                            controllerBloodSugar,
                                                        onChanged: (value) {
                                                          //controllerBloodSugar.text = controllerBloodSugar.text.replaceAll(',','.');
                                                        },
                                                        obscureText: false,
                                                        inputFormatters: <TextInputFormatter>[
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  '[0-9]')),
                                                        ],
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      216,
                                                                      216,
                                                                      216),
                                                            ),
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      216,
                                                                      216,
                                                                      216),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      RadioListTile(
                                                        value: 0,
                                                        groupValue: _groupValue,
                                                        onChanged: (newValue) =>
                                                            setState(() =>
                                                                _groupValue =
                                                                    newValue!),
                                                        title: Text(
                                                          sh.getLanguageResource(
                                                              "before_the_meal"),
                                                        ),
                                                      ),
                                                      RadioListTile(
                                                        value: 1,
                                                        groupValue: _groupValue,
                                                        onChanged: (newValue) =>
                                                            setState(() =>
                                                                _groupValue =
                                                                    newValue!),
                                                        title: Text(
                                                          sh.getLanguageResource(
                                                              "after_the_meal"),
                                                        ),
                                                      ),
                                                      RadioListTile(
                                                        value: 2,
                                                        groupValue: _groupValue,
                                                        onChanged: (newValue) =>
                                                            setState(() =>
                                                                _groupValue =
                                                                    newValue!),
                                                        title: Text(
                                                          sh.getLanguageResource(
                                                              "fasting"),
                                                        ),
                                                      ),
                                                      RadioListTile(
                                                        value: 3,
                                                        groupValue: _groupValue,
                                                        onChanged: (newValue) =>
                                                            setState(() =>
                                                                _groupValue =
                                                                    newValue!),
                                                        title: Text(
                                                          sh.getLanguageResource(
                                                              "none_of_the_above"),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                else if (isMultiChoice == true)
                                                  Column(
                                                    children: [
                                                      for (var item in choices)
                                                        RadioListTile(
                                                          value: item['value'],
                                                          groupValue:
                                                              _groupValue,
                                                          onChanged: (newValue) =>
                                                              setState(() =>
                                                                  getChoose(
                                                                      item,
                                                                      newValue)),
                                                          title: Text(sh
                                                              .getLanguageResource(
                                                                  item[
                                                                      'text'])),
                                                        )
                                                    ],
                                                  )
                                                else
                                                  for (var i = 0;
                                                      i < inputList.length;
                                                      i++)
                                                    Container(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            sh.getLanguageResource(
                                                                inputList[i]
                                                                    ['title']),
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        150,
                                                                        159,
                                                                        162)),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          TextFormField(
                                                            scrollPadding:
                                                                EdgeInsets.all(
                                                                    160),
                                                            decoration:
                                                                InputDecoration(
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          216,
                                                                          216,
                                                                          216),
                                                                ),
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          216,
                                                                          216,
                                                                          216),
                                                                ),
                                                              ),
                                                            ),
                                                            controller:
                                                                _controllers[i],
                                                            obscureText: false,
                                                            focusNode: i == 0
                                                                ? focusNotToFirst
                                                                : null,
                                                            autofocus: i == 0
                                                                ? true
                                                                : false,
                                                            onChanged: (value) {
                                                              var checkValue =
                                                                  sh.checkValues(
                                                                      inputList[
                                                                              i]
                                                                          [
                                                                          'title'],
                                                                      value);
                                                              setState(() {
                                                                if (checkValue[
                                                                        'state'] ==
                                                                    -10) {
                                                                  inputList[i][
                                                                          'isValueValid'] =
                                                                      false;
                                                                  inputList[i][
                                                                          'errorParams'] =
                                                                      checkValue;
                                                                } else {
                                                                  inputList[i][
                                                                          'isValueValid'] =
                                                                      true;
                                                                  inputList[i][
                                                                          'errorParams'] =
                                                                      checkValue;
                                                                }
                                                              });
                                                            },
                                                            keyboardType: inputList[i]
                                                                            [
                                                                            'type'] !=
                                                                        "String" &&
                                                                    inputList[i]
                                                                            [
                                                                            'type'] !=
                                                                        "Integer"
                                                                ? TextInputType
                                                                    .numberWithOptions(
                                                                        decimal:
                                                                            true,
                                                                        signed:
                                                                            false)
                                                                : inputList[i][
                                                                            'type'] ==
                                                                        "Integer"
                                                                    ? TextInputType
                                                                        .number
                                                                    : TextInputType
                                                                        .text,
                                                            inputFormatters: inputList[i]
                                                                            [
                                                                            'type'] !=
                                                                        "String" &&
                                                                    inputList[i]
                                                                            [
                                                                            'type'] !=
                                                                        "Integer"
                                                                ? <TextInputFormatter>[
                                                                    FilteringTextInputFormatter
                                                                        .allow(RegExp(
                                                                            '[0-9.,]')),
                                                                  ]
                                                                : inputList[i][
                                                                            'type'] ==
                                                                        "Integer"
                                                                    ? <TextInputFormatter>[
                                                                        FilteringTextInputFormatter.allow(
                                                                            RegExp('[0-9]')),
                                                                      ]
                                                                    : null,
                                                          ),
                                                          if (inputList[i][
                                                                      'isValueValid'] !=
                                                                  null &&
                                                              !inputList[i][
                                                                  'isValueValid'])
                                                            Text(
                                                              sh
                                                                  .getLanguageResource(
                                                                      "min_max_valid")
                                                                  .toString()
                                                                  .replaceAll(
                                                                      "@min@",
                                                                      inputList[i]['errorParams']
                                                                              [
                                                                              'min']
                                                                          .toString())
                                                                  .replaceAll(
                                                                      "@unit@",
                                                                      inputList[i]
                                                                              [
                                                                              'errorParams']
                                                                          [
                                                                          'unit'])
                                                                  .replaceAll(
                                                                      "@max@",
                                                                      inputList[i]['errorParams']
                                                                              [
                                                                              'max']
                                                                          .toString()),
                                                              style: TextStyle(
                                                                  color:
                                                                      mainButtonColor),
                                                            ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                              ],
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (isLast)
                        Center(
                          child: Container(
                            width: 150,
                            margin: EdgeInsets.only(right: 2, bottom: 30),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(30),
                                  primary: mainButtonColor,
                                ),
                                onPressed: () async {
                                  sendValues();
                                },
                                child: !isSendEP
                                    ? Text(sh.getLanguageResource("send"))
                                    : Transform.scale(
                                        scale: 0.5,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        )),
                              ),
                            ),
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (var item in buttons)
                            Container(
                              width: 150,
                              margin: EdgeInsets.only(left: 10, bottom: 150),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: (item['isNo'])
                                      ? confirmButton
                                      : mainButtonColor,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    focusNotToFirst.unfocus();
                                  });
                                  prepareOutputs();
                                  if (item['next'] == endNode) {
                                    setState(() {
                                      isLast = true;
                                    });
                                    clearAll();
                                  } else {
                                    if (item['next'] != null) {
                                      findQuestionaire(item['next']);
                                    } else if (_next != null) {
                                      findQuestionaire(_next);
                                    }
                                  }
                                },
                                child: Text(sh.getLanguageResource(
                                  item['text'].toString().toLowerCase(),
                                )),
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget exitQuestionnaire(BuildContext context) {
    return AlertDialog(
      content: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.question_mark,
                    size: 80,
                    color: mainButtonColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      sh.getLanguageResource("are_you_sure_exit_questionnaire"),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(255, 158, 158, 158)),
                        onPressed: () async {
                          Navigator.of(context).pop(1);
                        },
                        child: Text(
                          sh.getLanguageResource("yes"),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: mainButtonColor,
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop(0);
                        },
                        child: Text(
                          sh.getLanguageResource("no"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget savedSuccessFully(BuildContext context) {
    return AlertDialog(
      content: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 80,
                    color: Color.fromARGB(255, 0, 73, 3),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(sh.getLanguageResource("questionnaire_was_successfully"),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(30),
                      primary: mainButtonColor,
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: !isSendEP
                        ? const Text("OK")
                        : Transform.scale(
                            scale: 0.5,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            )),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget onOpenImage(BuildContext context, Uint8List? imageText) {
    Widget? image;
    if (imageText != null)
      image = Image.memory(
        imageText!,
      );

    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 0,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 0,
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.close,
                            size: 30,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    height: 40,
                    padding: EdgeInsets.only(right: 10, left: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                  if (_helpText != null)
                    Html(
                      shrinkWrap: true,
                      data: _helpText,
                      style: {
                        '#': Style(
                          fontSize: FontSize(18),
                          maxLines: 10,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      },
                    ),
                  if (image != null)
                    AspectRatio(
                      aspectRatio: 2,
                      child: PhotoView.customChild(
                        backgroundDecoration:
                            BoxDecoration(color: Colors.transparent),
                        child: image,
                        minScale: PhotoViewComputedScale.contained * 1,
                        initialScale: PhotoViewComputedScale.contained,
                        basePosition: Alignment.topCenter,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
