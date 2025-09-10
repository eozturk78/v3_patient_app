import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:v3_patient_app/colors/colors.dart';
import 'package:v3_patient_app/model/language.dart';
import 'package:v3_patient_app/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../../main.dart';
import '../../shared/shared.dart';

import 'package:http/http.dart' as http;

class AgreementsPage extends StatefulWidget {
  const AgreementsPage({super.key});
  @override
  State<AgreementsPage> createState() => _AgreementsPageState();
}

class _AgreementsPageState extends State<AgreementsPage> {
  Shared sh = Shared();
  Apis apis = Apis();
  bool rememberMeState = false;
  bool check1 = false;
  bool check2 = false;
  bool check3 = false;
  bool isSendEP = false;
  @override
  void initState() {
    // TODO: implement initState
    getLanguageList();
    super.initState();
    sh.openPopUp(context, 'agreements');
  }

  List<Language> list = [];
  Language? selectedLanguage;
  getLanguageList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    Apis apis = Apis();
    apis.getLanguageList().then(
      (data) {
        setState(() {
          list = (data as List).map((e) => Language.fromJson(e)).toList();

          if (pref.getString("language") != null) {
            selectedLanguage = list.firstWhere(
                (element) => element.cultureName == pref.getString("language"));
          } else
            selectedLanguage = list.firstWhere((element) => element.id == 1);

          //isStarted = false;
        });
      },
      onError: (err) {
        setState(() {
          //isStarted = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
              child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                if (selectedLanguage != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 30,
                            height: 40,
                            child: SvgPicture.network(
                                '${apis.apiPublic}/resources/${selectedLanguage?.url}'),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            selectedLanguage!.languageName,
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => languageDialog(
                              context, list, selectedLanguage?.cultureName),
                        ).then((resp) async {
                          setState(() {
                            if (resp != null &&
                                resp?.id != selectedLanguage?.id) {
                              selectedLanguage = resp;
                            }
                          });

                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.setString(
                              "language", selectedLanguage!.cultureName);

                          apis
                              .getLanguageResources(
                                  selectedLanguage!.cultureName)
                              .then((resp) {
                            setState(() {
                              languageResource = jsonEncode(resp);
                            });
                          });
                        });
                      },
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/images/logo-imedcom.png",
                  width: 160,
                  height: 70,
                ),
                Text(
                  sh.getLanguageResource("welcome_to_imedcom"),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  sh.getLanguageResource("agreement_1"),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: mainButtonColor),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      check2 = !check2;
                    });
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return mainButtonColor; // Set to your login button color
                            }
                            return Color.fromARGB(136, 241, 241,
                                241); // Change to your desired unselected color
                          },
                        ),
                        onChanged: (value) {
                          setState(() {
                            check2 = !check2;
                          });
                        },
                        value: check2,
                      ),
                      Flexible(
                          child: Text(
                        sh.getLanguageResource("agreement_2"),
                        style: TextStyle(fontSize: 16),
                      ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      check3 = !check3;
                    });
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return mainButtonColor; // Set to your login button color
                            }
                            return Color.fromARGB(136, 241, 241,
                                241); // Change to your desired unselected color
                          },
                        ),
                        onChanged: (value) {
                          setState(() {
                            check3 = !check3;
                          });
                        },
                        value: check3,
                      ),
                      Flexible(
                          child: Text(
                        sh.getLanguageResource("agreement_3"),
                        style: TextStyle(fontSize: 16),
                      ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  sh.getLanguageResource("agreement_4"),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: mainButtonColor),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Checkbox(
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return mainButtonColor; // Set to your login button color
                          }
                          return Color.fromARGB(136, 241, 241,
                              241); // Change to your desired unselected color
                        },
                      ),
                      onChanged: (value) {
                        setState(() {
                          check1 = !check1;
                        });
                      },
                      value: check1,
                    ),
                    Flexible(
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed('/terms-and-conditions');
                          },
                          child: Text(
                            sh.getLanguageResource("agreement_5"),
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/privacy-policy');
                    },
                    child: Text(
                      sh.getLanguageResource("agreement_6"),
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    )),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    backgroundColor: mainButtonColor,
                  ),
                  onPressed: () async {
                    if (check1 && check2 && check3) {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();

                      pref.setBool("isAgreementRead", true);
                      pref.setBool("agreementAccepted", true);
                      var token = pref.getString("token");
                      if (token != null && token != "null" && token != "")
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/main-menu', ModalRoute.withName("/main-menu"));
                      else
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login', ModalRoute.withName("/"));
                    } else {
                      await showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: Text("Konfirmation"),
                            content: Text(
                                "Sind Sie sicher, dass Sie gehen wollen, ohne allen Bedingungen zuzustimmen?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();

                                  var user = pref.getString("userName");
                                  pref.setBool(
                                      "${user}_isAgreementRead", false);

                                  pref.remove("token");
                                  //  pref.remove("userName");
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/login', ModalRoute.withName("/"));
                                },
                                child: Text("Ja"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(dialogContext)
                                      .pop(); // Return false to not pop
                                },
                                child: Text("Nein"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text(
                    sh.getLanguageResource("further"),
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}

Widget languageDialog(
    BuildContext context, List<Language> list, String? selectedLang) {
  Language? _selectedLang;
  Apis apis = Apis();
  return AlertDialog(
    content: StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Container(
          height: 230,
          child: Column(
            children: [
              for (var item in list)
                GestureDetector(
                  onTap: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.setString("language", item.cultureName);

                    setState(() {
                      selectedLang = item.cultureName;
                      _selectedLang = item;
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
                          Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.check,
                              color: mainButtonColor,
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(_selectedLang);
                },
                child: Text("OK"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  backgroundColor: mainButtonColor,
                ),
              )
            ],
          ),
        );
      },
    ),
  );
}
