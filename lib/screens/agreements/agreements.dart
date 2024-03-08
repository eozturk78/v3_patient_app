import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/model/language.dart';
import 'package:patient_app/shared/toast.dart';
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
  }

  List<Language> list = [];
  Language? selectedLanguage;
  getLanguageList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    Apis apis = Apis();
    apis.getLanguageList().then(
      (data) {
        setState(() {
          print(data);
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
                            print(resp);
                            if (resp != null &&
                                resp?.id != selectedLanguage?.id) {
                              selectedLanguage = resp;
                            }
                          });

                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.setString(
                              "language", selectedLanguage!.cultureName);

                          var url =
                              '${apis.apiPublic}/resources/${selectedLanguage!.cultureName}.json';
                          http.get(Uri.parse(url)).then((result) {
                            setState(() {
                              languageResource = result.body;
                            });
                            print(languageResource);
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
                const Text(
                  "Willkomen bei iMedCom",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Im Rahmen der iMedCom-App-Nutzung werden personenbezogene Daten  verarbeitet:",
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
                      const Flexible(
                          child: Text(
                        "Ich möchte mit meinem Arzt bzw.  meiner Ärztin über „iMedCom-App“ kommunizieren und willige ein, dass meine personenbezogenen Gesundheitsdaten für den bestimmungsgemäßen Gebrauch verarbeitet werden. Ich kann meine Einwilligung jederzeit mit Wirkung für die Zukunft widerrufen. Bitte beachten Sie jedoch, dass Ihr Benutzerkonto gelöscht wird, wenn Sie Ihre Einwilligung widerrufen, da die App ohne Ihre Einwilligung nicht genutzt werden darf. ",
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
                      const Flexible(
                          child: Text(
                        "Ich willige ein, dass die iMedCom GmbH, Weinbergweg 23, 06120 Halle an der Saale meine Daten verarbeiten darf, um die technische Funktionsfähigkeit und die Nutzerfreundlichkeit der App weiterzuentwickeln. Die Einwilligung ist jederzeit widerrufbar ohne Auswirkungen auf den Funktionsumfang der App. ",
                        style: TextStyle(fontSize: 16),
                      ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Damit Sie iMedCom verwenden dürfen , müssen folgende Voraussetzungen erfüllt sein:",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: mainButtonColor),
                ),
                const SizedBox(
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
                          child: const Text(
                            "Ich stimme den Nutzungsbedingungen zu.",
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
                    child: const Text(
                      "Weitere Hinweise zur Datenverarbeitung finden Sie in unserer Datenschutzinformation.",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    )),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    primary: mainButtonColor,
                  ),
                  onPressed: () async {
                    if (check1 && check2 && check3) {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();

                      var user = pref.getString("userName");
                      if (user != null && user != "null" && user != "")
                        pref.setBool("${user}_isAgreementRead", true);
                      else {
                        pref.setBool("agreementAccepted", true);
                      }

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
                    "Weiter",
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
                  primary: mainButtonColor,
                ),
              )
            ],
          ),
        );
      },
    ),
  );
}
