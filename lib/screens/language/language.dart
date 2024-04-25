import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:patient_app/apis/apis.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/model/language.dart';
import 'package:patient_app/screens/communication/calendar.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:patient_app/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../shared/bottom-menu.dart';

import 'package:http/http.dart' as http;

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  List<Language> list = [];
  Shared sh = Shared();
  bool isStarted = false;
  String selectedLang = "de-DE";
  @override
  void initState() {
    super.initState();
    getLanguageList();
    sh.openPopUp(context, 'language');
  }

  getLanguageList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    Apis apis = Apis();
    setState(() {
      isStarted = true;
      selectedLang = pref.getString("language")!;
    });
    apis.getLanguageList().then(
      (data) {
        setState(() {
          list = (data as List).map((e) => Language.fromJson(e)).toList();
          isStarted = false;
        });
      },
      onError: (err) {
        setState(() {
          isStarted = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage(sh.getLanguageResource("language"), context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: isStarted
              ? Center(
                  child: CircularProgressIndicator(
                    color: mainButtonColor,
                  ),
                )
              : list.isEmpty
                  ? Center(child: Text(sh.getLanguageResource("no_data_found")))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      verticalDirection: VerticalDirection.down,
                      children: [
                        for (var item in list)
                          GestureDetector(
                            onTap: () async {
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              pref.setString("language", item.cultureName);

                              apis
                                  .getLanguageResources(item!.cultureName)
                                  .then((resp) {
                                setState(() {
                                  languageResource = jsonEncode(resp);
                                });
                              });
                              setState(() {
                                selectedLang = item.cultureName;

                                apis.setPatientLanguage(item.cultureName).then(
                                  (data) {
                                    setState(() {
                                      isStarted = false;
                                    });
                                  },
                                  onError: (err) {
                                    setState(() {
                                      isStarted = false;
                                    });
                                  },
                                );
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 1,
                              padding: const EdgeInsets.only(
                                  left: 20, right: 10, top: 10, bottom: 10),
                              margin: EdgeInsets.only(bottom: 15),
                              constraints: const BoxConstraints(
                                maxHeight: double.infinity,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedLang == item.cultureName
                                      ? mainButtonColor
                                      : Color.fromARGB(255, 233, 232, 232),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 45,
                                    child: SvgPicture.network(
                                        '${apis.apiPublic}/resources/${item.url}'),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    item.languageName,
                                    style: selectedLang == item.cultureName
                                        ? TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: mainButtonColor)
                                        : null,
                                  ),
                                  if (selectedLang == item.cultureName)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: mainButtonColor,
                                        )
                                      ],
                                    )
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 4),
    );
  }
}
