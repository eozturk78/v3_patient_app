import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/shared.dart';
import '../shared/toast.dart';
import 'package:intl/intl.dart';

class Apis {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Shared sh = new Shared();
  String lang = 'tr-TR';
  String? baseUrl = 'https://v2test-api.imc-app.de/api';
  String? apiPublic = 'https://v2test-api.imc-app.de';
  String? othBaseUrl = 'https://praxiskamalmeo-test.oth.io';

  Future login(String email, String password) async {
    String finalUrl = '$baseUrl/patientlogin';
    var params = {
      'username': email.toString(),
      'password': password.toString()
    };
    var result = await http.post(Uri.parse(finalUrl),
        body: jsonEncode(params),
        headers: {'Content-Type': 'application/text', 'lang': lang});
    return getResponseFromApi(result);
  }

  Future patientInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/patientinfo';
    var result = await http.get(Uri.parse(finalUrl), headers: {
      'Content-Type': 'application/text',
      'lang': lang,
      'token': pref.getString('token').toString()
    });
    return getResponseFromApi(result);
  }

  Future getMeasurementList(DateTime date, String type) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var dateString = date.toString().replaceAll(" ", "T").toString();
    String finalUrl =
        '$baseUrl/getpatientmeasuremensresults?type=$type&from=$dateString';
    var result = await http.get(Uri.parse(finalUrl), headers: {
      'Content-Type': 'application/text',
      'lang': lang,
      'token': pref.getString('token').toString()
    });
    return getResponseFromApi(result);
  }

  Future getPatientMeasurement() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/getpatientallmeasurement';
    var result = await http.get(Uri.parse(finalUrl), headers: {
      'Content-Type': 'application/text',
      'lang': lang,
      'token': pref.getString('token').toString()
    });
    return getResponseFromApi(result);
  }

  Future getPatientMedicalPlanList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/getpatientmedicalplan';
    var result = await http.get(Uri.parse(finalUrl), headers: {
      'Content-Type': 'application/text',
      'lang': lang,
      'token': pref.getString('token').toString()
    });
    return getResponseFromApi(result);
  }

  Future getPatientNotificationList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/getpatientnotificationlist';
    var result = await http.get(Uri.parse(finalUrl), headers: {
      'Content-Type': 'application/text',
      'lang': lang,
      'token': pref.getString('token').toString()
    });
    return getResponseFromApi(result);
  }

  Future getPatientThreadMessages(String thread) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/getpatientthreadmessages?thread=${thread}';
    var result = await http.get(Uri.parse(finalUrl), headers: {
      'Content-Type': 'application/text',
      'lang': lang,
      'token': pref.getString('token').toString()
    });
    return getResponseFromApi(result);
  }

  Future getAttachmentDataUrl(imageUrl) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/getattachmentdataurl?url=$imageUrl';
      var result = await http.get(Uri.parse(finalUrl),
          headers: {'lang': lang, 'token': pref.getString('token').toString()});
      final data = result.bodyBytes;
      // and encode them to base64
      final base64data = base64Encode(data);
      Uint8List _bytesImage = Base64Decoder().convert(base64data);
      return _bytesImage;
    } catch (err) {
      throw Exception("can't decode");
    }
  }

  Future getPatientFolders() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/getpatientfolders';
      var result = await http.get(Uri.parse(finalUrl), headers: {
        'Content-Type': 'application/text',
        'lang': lang,
        'token': pref.getString('token').toString()
      });
      return getResponseFromApi(result);
    } catch (err) {
      print(err);
      throw Exception("can't decode");
    }
  }

  Future getPatientFiles(int folderId) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/getpatientfiles?folderid=$folderId';
      var result = await http.get(Uri.parse(finalUrl), headers: {
        'Content-Type': 'application/text',
        'lang': lang,
        'token': pref.getString('token').toString()
      });
      return getResponseFromApi(result);
    } catch (err) {
      print(err);
      throw Exception("can't decode");
    }
  }

  /*
  Future getPatientOnlineMeetings() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/getpatientonlinemeetings';
      var result = await http.get(Uri.parse(finalUrl), headers: {
        'Content-Type': 'application/text',
        'lang': lang,
        'token': pref.getString('token').toString()
      });
      return getResponseFromApi(result);
    } catch (err) {
      print(err);
      throw Exception("can't decode");
    }
  }

   */

  Future<List<Map<String, dynamic>>> fetchEvents() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    final response = await http
        .get(Uri.parse('$baseUrl/getpatientonlinemeetings'), headers: {
      'Content-Type': 'application/text',
      'lang': lang,
      'token': pref.getString('token').toString()
    });
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData
          .map((event) => {
                'id': event['id'],
                'title': event['meeting_title'],
                'date': event['meeting_date'],
                'link': event['meeting_link'],
              })
          .toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future sendMessage(String message, String organization) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/sendmessage';
    var params = {'message': message.toString(), 'organization': organization};
    var result = await http.post(Uri.parse(finalUrl),
        body: params,
        headers: {'lang': lang, 'token': pref.getString('token').toString()});
    return getResponseFromApi(result);
  }

  Future sendMessageWithAttachment(
      String message, image, String organization) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/sendmessage';
    var params = {
      'message': message.toString(),
      'image': image,
      'organization': organization
    };
    var result = await http.post(Uri.parse(finalUrl),
        body: params,
        headers: {'lang': lang, 'token': pref.getString('token').toString()});
    return getResponseFromApi(result);
  }

  Future setPatientFile(File file, String fileName, int folderId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/setpatientfile';
    var request = http.MultipartRequest("POST", Uri.parse(finalUrl));
    request.fields['fileName'] = fileName;
    request.fields['folderId'] = folderId.toString();
    request.files.add(http.MultipartFile.fromBytes(
        'file', await file.readAsBytes(),
        filename: '$fileName.pdf'));
    request.headers
        .addAll({'lang': lang, 'token': pref.getString('token').toString()});
    var response = await request.send();
    var result = await http.Response.fromStream(response);
    return getResponseFromApi(result);
  }

  Future registerPatient(
      String userName,
      String firstName,
      String lastName,
      String birthDate,
      String weight,
      String height,
      String gender,
      String email,
      String password,
      String sex) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/registerPatient';
    var params = {
      'userName': userName,
      'email': userName,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate.toString().substring(0, 10),
      'weight': weight,
      'height': height,
      'sex': sex
    };
    var result = await http
        .post(Uri.parse(finalUrl), body: params, headers: {'lang': lang}); /**/
    return getResponseFromApi(result);
  }

  Future getQuestionnaireGroups() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/getquestionnairegroups';
      var result = await http.get(Uri.parse(finalUrl), headers: {
        'Content-Type': 'application/text',
        'lang': lang,
        'token': pref.getString('token').toString()
      });
      return getResponseFromApi(result);
    } catch (err) {
      throw Exception("can't decode");
    }
  }

  Future setMeasurementValues(dynamic outPuts, String qid) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/setmeasurementvalues?qid=$qid';
    var result = await http.post(Uri.parse(finalUrl),
        body: jsonEncode(outPuts),
        headers: {'lang': lang, 'token': pref.getString('token').toString()});
    return getResponseFromApi(result);
  }

  getQuestionnaireResults(String questionnaireGroupId) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl =
          '$baseUrl/getquestionnairegroupdetails?questionnaireGroupId=$questionnaireGroupId';
      var result = await http.get(Uri.parse(finalUrl), headers: {
        'Content-Type': 'application/text',
        'lang': lang,
        'token': pref.getString('token').toString()
      });
      return getResponseFromApi(result);
    } catch (err) {
      throw Exception("can't decode");
    }
  }

  Future getpatientmaindata() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/getpatientmaindata';
      var result = await http.get(Uri.parse(finalUrl), headers: {
        'Content-Type': 'application/text',
        'lang': lang,
        'token': pref.getString('token').toString()
      });
      return getResponseFromApi(result);
    } catch (err) {
      throw Exception("can't decode");
    }
  }

  sendQuestionnaireResult(List<dynamic> outputs, String questionnaireId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl =
        '$baseUrl/sendquestionnaireresult?questionnaireId=$questionnaireId';
    var result = await http.post(Uri.parse(finalUrl),
        body: outputs,
        headers: {'lang': lang, 'token': pref.getString('token').toString()});
    return getResponseFromApi(result);
  }

  getResponseFromApi(http.Response result) {
    print(result.body);
    var body = jsonDecode(result.body);
    if (result.statusCode == 200 || result.statusCode == 201) {
      try {
        return body;
      } on Exception catch (err) {
        showToast("something went wrong");
        throw Exception("Something went wrong");
      }
    } else {
      body = jsonDecode(body);
      showToast(body['message']);
      throw Exception(body['message']);
    }
  }
}
