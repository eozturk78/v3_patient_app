import 'dart:convert';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/question-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:patient_app/shared/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../shared/document-box.dart';

class SendResultPage extends StatefulWidget {
  const SendResultPage({super.key});

  @override
  State<SendResultPage> createState() => _SendResultPageState();
}

class _SendResultPageState extends State<SendResultPage> {
  dynamic _groupValue = "";
  Enums enumCls = Enums();
  Apis apis = Apis();
  bool isStarted = true;
  PDFDocument? document;
  late String title;
  String? imageUrl;
  dynamic question = {};
  List<dynamic> inputList = [];
  List<dynamic> choices = [];
  bool isMultiChoice = false;
  var _controllers = [];

  @override
  void initState() {
    super.initState();
    getResult();
  }

  getResult() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(pref.getString('objectResponse'));
    question = jsonDecode(pref.getString('objectResponse')!);
    setState(() {
      title = question['text'] ?? question['question'];
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
            /* En the option is enum */
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
              _controllers.add(TextEditingController());
              inputList.add(question[key]);
              inputList[inputList.length - 1]['title'] =
                  question['existsKeys'][i];
            }
          }
        }
      }
    });
  }

  sendData() {
    for (var i = 0; i < inputList.length; i++) {
      var output = question[inputList[i]['title']];
      var p = {
        'name': output['name'],
        'type': output['type'],
        'value': _controllers[i].text
      };
      print(p);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage(title, context),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                title,
                style: labelText,
              ),
              if (isMultiChoice == true)
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
                  if (inputList[i]['type'] == 'Integer' ||
                      inputList[i]['type'] == 'Float' ||
                      inputList[i]['type'] == 'Object[]')
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
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                              color: const Color.fromARGB(255, 134, 134, 134)),
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
                        ElevatedButton(onPressed: () {}, child: Text("Yes")),
                        SizedBox(
                          width: 12,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("No"),
                          style: ElevatedButton.styleFrom(
                              primary:
                                  const Color.fromARGB(255, 158, 158, 158)),
                        )
                      ],
                    ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  primary: mainButtonColor,
                ),
                onPressed: () async {
                  sendData();
                },
                child: Text("SENDEN"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
