import 'dart:convert';
import 'dart:typed_data';

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
    print(finalUrl);
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
    var patientId = pref.getString('patientId');
    var dateString = date.toString().replaceAll(" ", "T").toString();
    String finalUrl =
        '$othBaseUrl/clinician/api/patients/$patientId/measurements?type=$type&from=$dateString&max=10000';
    var result = await http.get(Uri.parse(finalUrl), headers: {
      'Authorization': 'Bearer ${pref.getString('token').toString()}'
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

  getResponseFromApi(Response result) {
    print(result.statusCode);
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
