import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:v3_patient_app/apis/apis.dart';
import 'package:v3_patient_app/main.dart';
import 'package:v3_patient_app/model/message-notification.dart';
import 'package:v3_patient_app/model/search-menu.dart';
import 'package:v3_patient_app/screens/login/login.dart';
import 'package:v3_patient_app/screens/main-menu/main-menu.dart';
import 'package:v3_patient_app/screens/shared/bottom-menu.dart';
import 'package:v3_patient_app/screens/shared/shared.dart';
import 'package:v3_patient_app/shared/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isLoggedIn = false;

int tokenTimeOutSecond = 0;
int tokenTimeOutSecondDB = 0;
int popUpAppearSecond = 0;
MessageNotification? chosenMedicationPlan;
Timer? _timer;

class Shared {
  var outputFormat = DateFormat('dd/MM/yyyy HH:mm');
  List<dynamic> measurementType = [
    {"name": "weight", "min": 35, "max": 300, "unit": 'kg'},
    {"name": "saturation", "min": 50, "max": 100, "unit": '%'},
    {"name": "temperature", "min": 32.5, "max": 43, "unit": '°C'},
    {"name": "bloodSugar", "min": 1, "max": 30, "unit": '°C'},
    {"name": "pulse", "min": 45, "max": 200, "unit": 'bpm'},
    {"name": "bloodPressure", "min": 60, "max": 250, "unit": ''},
    {"name": "crp", "min": 0, "max": 10, "unit": ''},
    {"name": "dailySteps", "min": 0, "max": 90000, "unit": ''},
    {"name": "dailyStepsWeeklyAverage", "min": 0, "max": 90000, "unit": 'cm'},
    {"name": "height", "min": 0, "max": 250, "unit": 'cm'},
    {"name": "hemoglobin", "min": 0, "max": 10, "unit": ''},
    {"name": "peakFlow", "min": 300, "max": 600, "unit": ''},
    {"name": "respiratoryRate", "min": 0, "max": 40, "unit": ''},
    {"name": "sitToStand", "min": 0, "max": 30, "unit": ''},
    {"name": "systolic", "min": 60, "max": 250, "unit": 'mmHg'},
    {"name": "diastolic", "min": 40, "max": 150, "unit": 'mmHg'},
  ];
  String galeryPermissionText =
      "Um fortzufahren ändern Sie die Einstellungen zum Zugriff auf Bilder.";
  String cameraPermissionText =
      "Um fortzufahren ändern Sie die Einstellungen zum Zugriff auf die Kamera.";
  String storagePermissionText =
      "Um fortzufahren ändern Sie die Einstellungen zum Zugriff auf Dokumente.";

  emailValidator(text) {
    if (text == null || text.isEmpty) {
      return '* Pflichfeld';
    } else if (!(text.contains('@')) && text.isNotEmpty) {
      return "Enter valid email.";
    }
    return null;
  }

  textValidator(text) {
    if (text == null || text?.isEmpty) {
      return '* Pflichfeld';
    }
    return null;
  }

  textRepeatPassword(pass1, pass2) {
    if (pass2 == null || pass2?.isEmpty) {
      return '* Pflichfeld';
    }
    if (pass1 != pass2) {
      return 'Passwords dont match';
    }
    return null;
  }

  numberFormatter(double? number) {
    if (number == null) return "0,0000";
    var formatter = NumberFormat('#,###.0000');
    var result = formatter.format(number);
    var pureNumber =
        result.substring(0, result.indexOf('.')).replaceAll(',', '.');
    var decimal = result.toString().substring(result.indexOf('.') + 1);
    if (pureNumber == "") pureNumber = "0";
    return "$pureNumber,$decimal";
  }

  prePareNumberForRequest(String number) {
    return number.replaceAll(".", "").replaceAll(",", ".");
  }

  getBaseName(String url) {
    return url.toString().substring(url.lastIndexOf('/') + 1);
  }

  formatDate(String date) {
    DateTime parseDate;
    if (!date.toString().contains("T")) {
      date = date.toString().replaceAll(" ", "T");
    }
    parseDate = new DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd.MM.yy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  formatDateTime(String date) {
    var d = date.length > 10
        ? DateTime.parse(date).toLocal()
        : DateTime.parse(date).toLocal().toString().substring(0, 10);
    var listData = d.toString().split(" ");
    var dateList = listData[0].split("-");
    var time = "";
    if (d.toString().length > 10) time = listData[1].substring(0, 5);

    var day = dateList[2];
    var month = dateList[1];
    var year = dateList[0];
    var outputDate = '$day.$month.$year $time';
    return outputDate;
  }

  formatDateTimeToRequest(String date) {
    var listData = date.toString().split("/");

    var day = listData[0];
    if (day.toString().length == 1) day = '0${day}';
    var month = listData[1];
    if (month.toString().length == 1) month = '0${month}';
    var year = listData[2].toString().substring(0, listData[2].indexOf(" "));

    var time = listData[2].toString().substring(listData[2].indexOf(" ") + 1);

    var timeData = time.toString().split(":");

    var hour = timeData[0];
    if (hour.toString().length == 1) hour = '0${hour}';
    var min = timeData[1];
    if (min.toString().length == 1) min = '0${min}';

    var outputDate = '$year-$month-${day}T${hour}:${min}';
    return outputDate;
  }

  formatDateImc(String date) {
    DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd.MM.yyyy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  bool hasUpperCase(String string) {
    if (string == null) {
      return false;
    }
    if (string.isEmpty) {
      return false;
    }

    for (var i = 0; i < string.length; i++) {
      if (!hasSpecialChars(string[i]) && string[i].toUpperCase() == string[i])
        return true;
    }
    return false;
  }

  bool hasLowerCase(String string) {
    if (string == null) {
      return false;
    }
    if (string.isEmpty) {
      return false;
    }

    for (var i = 0; i < string.length; i++) {
      if (!hasSpecialChars(string[i]) && string[i].toLowerCase() == string[i])
        return true;
    }
    return false;
  }

  checkValues(question, value) {
    try {
      var dontAllowSend = false;
      if (value.toString().contains(','))
        value = value.toString().replaceAll(",", '.');
      value = double.parse(value);
      if (question == "weight" && (value < 35 || value > 300)) {
        var p = measurementType
            .where((element) => element['name'] == 'weight')
            ?.first;
        p['state'] = -10;
        return p;
      } else if (question == "saturation" && (value < 50 || value > 100)) {
        var p = measurementType
            .where((element) => element['name'] == 'saturation')
            ?.first;
        p['state'] = -10;
        return p;
      } else if (question == "temperature" && (value < 32.5 || value > 43)) {
        var p = measurementType
            .where((element) => element['name'] == 'temperature')
            ?.first;
        p['state'] = -10;
        return p;
      } else if (question == "bloodSugar" && (value < 1 || value > 30)) {
        var p = measurementType
            .where((element) => element['name'] == 'bloodSugar')
            ?.first;
        p['state'] = -10;
        return p;
      } else if (question == "pulse" && (value < 45 || value > 200)) {
        var p = measurementType
            .where((element) => element['name'] == 'pulse')
            ?.first;
        p['state'] = -10;
        return p;
      } else if (question == "bloodPressure" && (value < 60 || value > 250)) {
        var p = measurementType
            .where((element) => element['name'] == 'bloodPressure')
            ?.first;
        p['state'] = -10;
        return p;
      } else if (question == "crp" && (value < 0 || value > 10)) {
        var p =
            measurementType.where((element) => element['name'] == 'crp')?.first;
        p['state'] = -10;
        return p;
      } else if (question == "dailySteps" && (value < 0 || value > 90000)) {
        var p = measurementType
            .where((element) => element['name'] == 'dailySteps')
            ?.first;
        p['state'] = -10;
        return p;
      } else if (question == "dailyStepsWeeklyAverage" &&
          (value < 0 || value > 90000)) {
        var p = measurementType
            .where((element) => element['name'] == 'dailyStepsWeeklyAverage')
            ?.first;
        p['state'] = -10;
        return p;
      } else if (question == "height" && (value < 0 || value > 250)) {
        var p = measurementType
            .where((element) => element['name'] == 'height')
            ?.first;
        p['state'] = -10;
        return p;
      } else if (question == "hemoglobin" && (value < 0 || value > 10)) {
        var p = measurementType
            .where((element) => element['name'] == 'hemoglobin')
            ?.first;
        p['state'] = -10;
        return p;
      } else if (question == "peakFlow" && (value < 300 || value > 600)) {
        var p = measurementType
            .where((element) => element['name'] == 'peakFlow')
            ?.first;
        p['state'] = -10;
        return p;
      } else if (question == "respiratoryRate" && (value < 0 || value > 40)) {
        var p = measurementType
            .where((element) => element['name'] == 'respiratoryRate')
            ?.first;
        p['state'] = -10;
        return p;
      } else if (question == "sitToStand" && (value < 0 || value > 30)) {
        var p = measurementType
            .where((element) => element['name'] == 'sitToStand')
            ?.first;
        p['state'] = -10;
        return p;
      } else if (question == "systolic" && (value < 60 || value > 250)) {
        var p = measurementType
            .where((element) => element['name'] == 'systolic')
            ?.first;
        p['state'] = -10;
        return p;
      } else if (question == "diastolic" && (value < 40 || value > 150)) {
        var p = measurementType
            .where((element) => element['name'] == 'diastolic')
            ?.first;
        p['state'] = -10;
        return p;
      }

      return {'state': 10};
    } catch (err) {
      return {'state': 10};
    }
  }

  bool hasSpecialChars(String string) {
    return string.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_-]'));
  }

  redirectPatient(error, BuildContext? context) {
    try {
      var errorStatus = error['error'] ?? "";
      var _context = context;
      if (context == null) _context = navigatorKey.currentContext;

      if (errorStatus == "expired") {
        // change password redirection
        Navigator.of(_context!).pushNamed('/change-password');
      } else if (errorStatus == 'tokenexpired') {
        Navigator.of(_context!).pushNamed('/login');
      }
    } catch (e) {}
  }

  checkPermission(
      BuildContext context, Permission permission, String warningText) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var listCount = 1;
    var prefText = 'perm${permission.toString()}';
    if (pref.getString(prefText) != null) {
      listCount = int.parse(pref.getString(prefText)!);
      listCount++;
    }

    pref.setString(prefText, listCount.toString());
    if (await permission.isGranted == false) {
      if ((Platform.isIOS && listCount > 1) ||
          (Platform.isAndroid && listCount > 2))
        showDialog(
          context: context,
          builder: (context) => openSettingsDialog(context, warningText),
        ).then((resp) {
          //  Navigator.pop(context, resp);
        });
      final result = await permission.request();

      if (result.isGranted) {
        return true;
      } else if (result.isDenied) {
        return false;
      } else if (result.isPermanentlyDenied) {
        return false;
      }
    }
    return true;
  }

  getLanguageResource(String? resourceName) {
    var translation = jsonDecode(languageResource)[resourceName];
    if (translation != null) return translation;
    return resourceName;
  }

  setCurrentScreen(String page) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setString("currentPage", '/$page');
    getUnReadMessageCount();
  }

  getUnReadMessageCount() {
    Apis apis = Apis();

    /* apis.getUnReadMessageCount().then((value) {
      navigatorKey.currentState!.setState(() {
        if (value != null) unreadMessageCount = value['unreadmessagecount'];
      });
    });*/
  }

  StateSetter? _setState;

  openPopUp(BuildContext context, String page) {
    if (tokenTimeOutSecondDB == 0) return;
    if (tokenTimeOutSecond > 0) tokenTimeOutSecond = tokenTimeOutSecondDB;
    const oneSec = const Duration(seconds: 1);
    setCurrentScreen(page);
    _timer?.cancel();
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        _timer = timer;
        if (tokenTimeOutSecond == popUpAppearSecond) {
          showDialog(
            context: navigatorKey.currentState!.overlay!.context,
            builder: (BuildContext context) => StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                _setState = setState;

                return AlertDialog(
                  title: Text(getLanguageResource('session_expiring')),
                  content: Container(
                    height: 50,
                    child: Column(
                      children: [
                        Text(
                          getLanguageResource('session_will_end'),
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("$tokenTimeOutSecond s")
                      ],
                    ),
                  ),
                );
              },
            ),
          ).then((value) {
            _setState = null;
            Apis apis = Apis();
            apis.patientrenewtoken().then((value) async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.setString("token", value['token']);

              tokenTimeOutSecondDB = value['tokenTimeOutSecond'];
              tokenTimeOutSecond = value['tokenTimeOutSecond'];
              popUpAppearSecond = value['popUpAppearSecond'];
            });
          });
        }
        if (tokenTimeOutSecond < popUpAppearSecond) {
          if (_setState != null)
            _setState!(() {
              tokenTimeOutSecond--;
            });
        } else {
          tokenTimeOutSecond--;
        }
        if (tokenTimeOutSecond <= 0) {
          timer.cancel();
          onLogOut();
        }
      },
    ); /* */
  }

  onLogOut() async {
    final navBarVisibility = Provider.of<NavBarVisibility>(
        navigatorKey.currentState!.overlay!.context,
        listen: false);

    Navigator.pop(navigatorKey.currentState!.overlay!.context);

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("token");
    hideNavBar = true;
    navBarVisibility.updateHideNavBar(true);

    showDialog(
      context: navigatorKey.currentState!.overlay!.context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return LoginPage(
            isDiaglog: true,
          );
        },
      ),
    ).then((value) {
      if (value == null) {
        exit(0);
      }
      var s = pref.getString("currentPage").toString();
      s = s.substring(1);
      openPopUp(navigatorKey.currentState!.overlay!.context, s);
    });
  }

  getMainSearchItems() {
    final searchAllRoutes = [
      SearchMenu(
        displayName: 'Erinnerungen',
        route: '/notification-history',
        type: 'menu',
        icon:
            SvgPicture.asset('assets/images/menu-icons/erinnerungen-main.svg'),
        keywords: getLanguageResource("settings"),
      ),
      SearchMenu(
        displayName: 'Auszug meiner Daten',
        route: '/extract-data',
        type: 'menu',
        icon: Icons.data_object,
        keywords: getLanguageResource("data_extract_keywords"),
      ),
      SearchMenu(
        displayName: 'Meine medizinischen Kontakte',
        route: '/patient-contacts-list',
        type: 'menu',
        icon: SvgPicture.asset('assets/images/menu-icons/nachrichten-main.svg'),
        keywords: getLanguageResource("contact_keywords"),
      ),
      SearchMenu(
        displayName: 'Meine Diagnosen',
        route: '/diagnoses',
        type: 'menu',
        icon: Icons.contact_page,
        keywords: getLanguageResource("diagnose_keywords"),
      ),
      SearchMenu(
        displayName: 'Über mich',
        route: '/about-me',
        type: 'menu',
        icon: Icons.person,
        keywords: getLanguageResource("profile_keywords"),
      ),
      SearchMenu(
        displayName: 'Temperatur - Bedeutung, Messung und Auswirkungen',
        route: '/temperature-description',
        type: 'menu',
        icon: Icons.description,
        keywords: getLanguageResource("temperature_keywords"),
      ),
      SearchMenu(
          displayName: 'Was ist die Herzfrequenz?',
          route: '/pulse-description',
          type: 'menu',
          icon: Icons.description,
          keywords: getLanguageResource("heart_rate_keywords")),
      SearchMenu(
          displayName: 'Blutdruck: Was ist das?',
          route: '/blutdruck-description',
          type: 'menu',
          icon: Icons.description,
          keywords: getLanguageResource("blood_pressure")),
      SearchMenu(
          displayName: 'Was ist die Sauerstoffsättigung im Blut?',
          route: '/saturation-description',
          type: 'menu',
          icon: Icons.description,
          keywords: getLanguageResource("oxygen_saturation")),
      SearchMenu(
          displayName: 'Welche Rolle spielt das Körpergewicht?',
          route: '/weight-description',
          type: 'menu',
          icon: Icons.description,
          keywords: getLanguageResource("body_weight_keywords")),
      SearchMenu(
          displayName: 'Meine Dokumente',
          route: '/documents',
          type: 'menu',
          icon: SvgPicture.asset('assets/images/menu-icons/dokumente-main.svg'),
          keywords: getLanguageResource("documents_keywords")),
      SearchMenu(
          displayName: 'Aufklärung',
          route: '/enlightenment',
          type: 'menu',
          icon:
              SvgPicture.asset('assets/images/menu-icons/aufklarung-main.svg'),
          keywords: getLanguageResource("clarification")),
      SearchMenu(
          displayName: 'Bibliothek',
          route: '/libraries',
          type: 'menu',
          icon:
              SvgPicture.asset('assets/images/menu-icons/bibliothek-main.svg'),
          keywords: getLanguageResource("library")),
      SearchMenu(
        displayName: 'Rezept',
        route: '/recipes',
        type: 'menu',
        icon: SvgPicture.asset('assets/images/menu-icons/rezept-main.svg'),
        keywords: getLanguageResource("recipe"),
      ),
      SearchMenu(
        displayName: 'Medikation',
        route: '/medication',
        type: 'menu',
        icon: SvgPicture.asset('assets/images/menu-icons/medikation-main.svg'),
        keywords: getLanguageResource("medication_keywords"),
      ),
      SearchMenu(
        displayName: 'Kalender',
        route: '/calendar',
        type: 'menu',
        icon: Icons.calendar_month_outlined,
        keywords: getLanguageResource("calendar"),
      ),
      SearchMenu(
        displayName: 'Mitteilungen',
        route: '/messages',
        type: 'menu',
        icon:
            SvgPicture.asset('assets/images/menu-icons/mitteilungen-main.svg'),
        keywords: getLanguageResource("message_keywords"),
      ),
      SearchMenu(
        displayName: 'Medikamentenplan',
        route: '/medication-plan-list',
        type: 'menu',
        icon: SvgPicture.asset('assets/images/menu-icons/medikation-main.svg'),
        keywords: getLanguageResource("medication_keywords"),
      ),
      SearchMenu(
        displayName: 'Infothek',
        route: '/info',
        type: 'menu',
        icon: SvgPicture.asset('assets/images/menu-icons/infothek-main.svg'),
        keywords: getLanguageResource("info_tech"),
      ),
      SearchMenu(
        displayName: 'Schnellzugriffsmenü',
        route: '/communication',
        type: 'menu',
        icon: SvgPicture.asset('assets/images/menu-icons/infothek-main.svg'),
        keywords: getLanguageResource("quick_access"),
      ),
      SearchMenu(
        displayName: 'Sauerstoffsättigung',
        route: '/measurement-result-saturation',
        type: 'menu',
        icon: SvgPicture.asset('assets/images/menu-icons/graphische-main.svg'),
        keywords: getLanguageResource("oxygen_saturation_keywords"),
      ),
      SearchMenu(
        displayName: 'Temperatur',
        route: '/measurement-result-temperature',
        type: 'menu',
        icon: SvgPicture.asset('assets/images/menu-icons/graphische-main.svg'),
        keywords: getLanguageResource("temperature_graph_keywords"),
      ),
      SearchMenu(
        displayName: 'Herzfrequenz',
        route: '/measurement-result-pulse',
        type: 'menu',
        icon: SvgPicture.asset('assets/images/menu-icons/graphische-main.svg'),
        keywords: getLanguageResource("heart_graph_keywords"),
      ),
      SearchMenu(
        displayName: 'Gewicht',
        route: '/measurement-result-weight',
        type: 'menu',
        icon: SvgPicture.asset('assets/images/menu-icons/graphische-main.svg'),
        keywords: getLanguageResource("body_weight_graph"),
      ),
      SearchMenu(
        displayName: 'Einstellungen',
        route: '/settings',
        type: 'menu',
        icon: Icons.settings,
        keywords: getLanguageResource("settings"),
      ),
      SearchMenu(
        displayName: 'Videosprechstunde',
        route: '/communication',
        type: 'menu',
        icon: Icons.video_call,
        keywords: getLanguageResource("video_consultation_keywords"),
      ),
      SearchMenu(
        displayName: 'Tägliche Messungen',
        route: '/questionnaire-group',
        type: 'menu',
        icon: SvgPicture.asset('assets/images/menu-icons/tagliche-main.svg'),
        keywords: getLanguageResource("daily_measurements"),
      ),
      SearchMenu(
        displayName: 'Grafische Darstellungen',
        route: '/communication',
        type: 'menu',
        icon: SvgPicture.asset('assets/images/menu-icons/graphische-main.svg'),
        keywords: getLanguageResource("temperature_graph_keywords"),
      ),
    ];
    return searchAllRoutes;
  }

  double parseIeee16BitSFloat(int byte1, int byte2) {
    Map<int, double> reservedValues = {
      0x07FE: double.nan,
      0x07FF: double.nan,
      0x0800: double.nan,
      0x0801: double.nan,
      0x0802: double.nan,
    };

    int ieee11073 = (byte1 & 0xFF) + (0x100 * (byte2 & 0xFF));
    int mantissa = ieee11073 & 0x0FFF;

    if (reservedValues.containsKey(mantissa)) {
      return reservedValues[mantissa]!;
    }

    if (mantissa >= 0x0800) {
      mantissa = -(0x1000 - mantissa);
    }

    int exponent = ieee11073 >> 12;
    if (exponent >= 0x08) {
      exponent = -(0x10 - exponent);
    }

    num magnitude = pow(10, exponent);
    return (mantissa * magnitude).toDouble();
  }
}
