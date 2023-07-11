import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/shared.dart';
import '../shared/toast.dart';

class Apis {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Shared sh = new Shared();
  String lang = 'tr-TR';
  String? baseUrl = 'https://v2test-api.imc-app.de/api';

  Future login(String email, String password) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/patientlogin';
    print(finalUrl);
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
    print(finalUrl);

    var result = await http.get(Uri.parse(finalUrl), headers: {
      'Content-Type': 'application/text',
      'lang': lang,
      'token': pref.getString('token').toString()
    });
    return getResponseFromApi(result);
  }

  getResponseFromApi(Response result) {
    var body = jsonDecode(result.body);
    if (body['errors'] == null || body['errors']?.length == 0) {
      try {
        return body;
      } on Exception catch (err) {
        showToast("something went wrong");
        throw Exception("Something went wrong");
      }
    } else {
      showToast(body['message']);
      throw Exception(body['message']);
    }
  }
}
