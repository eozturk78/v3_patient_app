import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  dynamic translations = {
    'dailySteps': 'Tägliche Schritte',
    'dailyStepsWeeklyAverage': 'Tägliche Schritte, Wochendurchschnitt',
    'respiratoryRate': 'Atemfrequenz',
    'diastolic': 'Diastolischer Blutdruck',
    'systolic': 'Systolischer Blutdruck',
    'peakFlow': 'Exspiratorischer Spitzenfluss',
    'puls': 'Pulse',
    'pulse': 'Pulse',
    'saturation': 'Sauerstoffsättigung',
    'comment': 'Kommentar',
    'weight': 'Gewicht',
    'temperature': 'Temperatur',
    "URINE_LEVEL_NEGATIVE": "Negativ",
    "URINE_LEVEL_PLUS_FOUR": "+4",
    "URINE_LEVEL_PLUS_MINUS": "+/-",
    "URINE_LEVEL_PLUS_ONE": "+1",
    "URINE_LEVEL_PLUS_THREE": "+3",
    "URINE_LEVEL_PLUS_TWO": "+2",
    "URINE_LEVEL_POSITIVE": "Positiv",
    "fatMass": "Fetmasse",
    "hemoglobin": "Hämoglobin",
    "height": "Körpergröße (cm)",
    "bodyCellMass": "Körperzellmasse",
    "phaseAngle": "Phasenwinkel",
    "oxygenFlow": "Sauerstofffluss",
    "painScale": "Schmerzskala",
    "sitToStand": "Sit-to-stand (STS)",
    "fev1": "FEV1",
    "fev6": "FEV6",
    "fev1Fev6Ratio": "FEV1/FEV6",
    "fef2575": "FEF25% -75%",
    "meanArterialPressure": "Mittlerer arterieller Blutdruck"
  };

  getTranslateion(String field) {
    print(field);
    return translations[field] != null ? translations[field] : field;
  }

  emailValidator(text) {
    if (text == null || text.isEmpty) {
      return 'This field is required';
    } else if (!(text.contains('@')) && text.isNotEmpty) {
      return "Enter valid email.";
    }
    return null;
  }

  textValidator(text) {
    if (text == null || text?.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  textRepeatPassword(pass1, pass2) {
    if (pass2 == null || pass2?.isEmpty) {
      return 'This field is required';
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
    var d = DateTime.parse(date).toLocal();
    var listData = d.toString().split(" ");
    var dateList = listData[0].split("-");
    var time = listData[1].substring(0, 5);
    var day = dateList[2];
    var month = dateList[1];
    var year = dateList[0];
    var outputDate = '$day.$month.$year $time';
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
      value = double.parse(value);
      print(question);
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

  redirectPatient(error, context) {
    print(error);
    var errorStatus = error['error'];
    if (errorStatus == "expired") {
      // change password redirection
      Navigator.of(context).pushNamed('/change-password');
    } else if (errorStatus == 'tokenexpired') {
      Navigator.of(context).pushNamed('/login');
    }
  }
}
