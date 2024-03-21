import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:patient_app/screens/agreements/agreements.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/shared/shared.dart';
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

  Future login(String email, String password, String? deviceToken) async {
    String finalUrl = '$baseUrl/patientlogin';
    var params = {
      'username': email.toString(),
      'password': password.toString(),
      'deviceToken': deviceToken
    };
    //TODO: try-catch
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

  Future getLanguageResources(String lang) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/getlanguageresources?lang=$lang';
    var result = await http.get(Uri.parse(finalUrl), headers: {
      'Content-Type': 'application/text',
      'lang': lang,
      'token': pref.getString('token').toString()
    });
    return getResponseFromApi(result);
  }

  Future getPatientContactsByCategory(String category) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/getPatientContactsByCategory';
      var params = {'category': category};
      var result = await http.post(Uri.parse(finalUrl),
          body: params,
          headers: {'lang': lang, 'token': pref.getString('token').toString()});
      return getResponseFromApi(result);
    } catch (err) {
      throw Exception("can't decode");
    }
  }

  Future createPatientContact(dynamic contactdata) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/createPatientContact';
      contactdata['category'] = contactdata['category'].toString();
      var result = await http.post(Uri.parse(finalUrl),
          body: contactdata,
          headers: {'lang': lang, 'token': pref.getString('token').toString()});
      return getResponseFromApi(result);
    } catch (err) {
      throw Exception("Can't create new contact!");
    }
  }

  Map<String, dynamic> convertNullValues(Map<String, dynamic> data) {
    Map<String, dynamic> result = {};
    data.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        result[key] =
            convertNullValues(value); // Recursively convert nested maps
      } else {
        result[key] = value ?? ''; // Replace null values with empty string
      }
    });
    return result;
  }

  Future updatePatientContact(Map<String, dynamic> contactdata) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/updatePatientContact';
      contactdata['category'] = contactdata['category'].toString();
      contactdata['id'] = contactdata['id'].toString();
      Map<String, dynamic> convertedData = convertNullValues(contactdata);
      var result = await http.post(Uri.parse(finalUrl),
          body: convertedData,
          headers: {'lang': lang, 'token': pref.getString('token').toString()});
      return getResponseFromApi(result);
    } catch (err) {
      throw Exception("Can't update the contact!");
    }
  }

  Future deletePatientContact(Map<String, dynamic> contactdata) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/deletePatientContact';

      contactdata['id'] = contactdata['id'].toString();

      Map<String, dynamic> convertedData = convertNullValues(contactdata);

      var result = await http.post(Uri.parse(finalUrl),
          body: convertedData,
          headers: {'lang': lang, 'token': pref.getString('token').toString()});
      return getResponseFromApi(result);
    } catch (err) {
      throw Exception(AppLocalizations.tr("Can't delete the contact!") ??
          "Can't delete the contact!");
    }
  }

  Future getPatientMedicationReminderPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/getPatientMedicationReminderPreference';
    var result = await http.get(Uri.parse(finalUrl), headers: {
      'Content-Type': 'application/text',
      'lang': lang,
      'token': pref.getString('token').toString()
    });

    var tmpval = getResponseFromApi(result);
    pref.setBool(
        'medication_notifications_enabled', tmpval == 1 ? true : false);

    return tmpval;
  }

  Future setPatientMedicationReminderPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var medicationReminderPreference =
        pref.getString('medication_notifications_enabled') == "true"
            ? true
            : false;
    String finalUrl = '$baseUrl/setPatientMedicationReminderPreference';
    var params = {
      'medication_reminder_preference': medicationReminderPreference.toString()
    };
    var result = await http.post(Uri.parse(finalUrl),
        body: params,
        headers: {'lang': lang, 'token': pref.getString('token').toString()});
    return getResponseFromApi(result);
  }

  Future getPatientCalendarEvents() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/getPatientCalendarEvents';
    var result = await http.get(Uri.parse(finalUrl), headers: {
      'Content-Type': 'application/text',
      'lang': lang,
      'token': pref.getString('token').toString()
    });
    return result;
  }

  Future getPatientOnlineMeetingEvents() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/getPatientOnlineMeetingEvents';
      var result = await http.get(Uri.parse(finalUrl), headers: {
        'Content-Type': 'application/text',
        'lang': lang,
        'token': pref.getString('token').toString()
      });
      return result;
    } catch (err) {
      throw Exception("can't decode");
    }
  }

  Future getPatientOnlineMeetings() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/getPatientOnlineMeetingEvents';
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

  Future getPatientFileEvents() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/getPatientFileEvents';
      var result = await http.get(Uri.parse(finalUrl), headers: {
        'Content-Type': 'application/text',
        'lang': lang,
        'token': pref.getString('token').toString()
      });
      return result;
    } catch (err) {
      throw Exception("can't decode");
    }
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
    String finalUrl = '$baseUrl/getpatientmedicalplanarchieve';
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
      print("=================");
      String finalUrl = '$baseUrl/getattachmentdataurl?url=$imageUrl';
      var result = await http.get(Uri.parse(finalUrl),
          headers: {'lang': lang, 'token': pref.getString('token').toString()});
      final data = result.bodyBytes;
      // print(result);
      // and encode them to base64
      final base64data = base64Encode(data);
      Uint8List _bytesImage = Base64Decoder().convert(base64data);
      return _bytesImage;
    } catch (err) {
      throw Exception("can't decode");
    }
  }

  Future getImageUrl(imageUrl) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$imageUrl';
      var result = await http.get(Uri.parse(finalUrl), headers: {
        'lang': lang,
        'Authorization': 'Bearer ' + pref.getString('token').toString()
      });
      final data = result.bodyBytes;
      // and encode them to base64
      final base64data = base64Encode(data);

      Uint8List _bytesImage = Base64Decoder().convert(result.body);
      print(_bytesImage);
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
      throw Exception("can't decode");
    }
  }

  Future setPatientFolderName(String? folderId, String folderName) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/setpatientfoldername';
      var body = {"foldername": folderName};
      if (folderId != null) body['folderid'] = folderId;
      var result = await http.post(Uri.parse(finalUrl),
          body: body,
          headers: {'lang': lang, 'token': pref.getString('token').toString()});
      return getResponseFromApi(result);
    } catch (err) {
      throw Exception("can't decode");
    }
  }

  Future deletePatientFolder(int folderId) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/deletepatientfolder?folderid=$folderId';
      var result = await http.delete(Uri.parse(finalUrl),
          headers: {'lang': lang, 'token': pref.getString('token').toString()});
      return getResponseFromApi(result);
    } catch (err) {
      throw Exception("can't decode");
    }
  }

  Future deletePatientFile(int fileId) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/deletepatientfile?fileid=$fileId';
      var result = await http.delete(Uri.parse(finalUrl),
          headers: {'lang': lang, 'token': pref.getString('token').toString()});
      return getResponseFromApi(result);
    } catch (err) {
      throw Exception("can't decode");
    }
  }

  Future deletePatientProfilePhoto() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/deletepatientprofilephoto';
      var result = await http.delete(Uri.parse(finalUrl),
          headers: {'lang': lang, 'token': pref.getString('token').toString()});
      return getResponseFromApi(result);
    } catch (err) {
      throw Exception("can't decode");
    }
  }

  Future getPatientFiles(int folderId) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/getpatientfiles?folderid=$folderId';
      var result = await http.get(Uri.parse(finalUrl),
          headers: {'lang': lang, 'token': pref.getString('token').toString()});
      return getResponseFromApi(result);
    } catch (err) {
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

  Future fetchMedicationPlansOfDay(String selecteddate) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl =
        '$baseUrl/getmedicationplansbeforedate?cutoffdate=$selecteddate';
    var result = await http.get(Uri.parse(finalUrl), headers: {
      'Content-Type': 'application/text',
      'lang': lang,
      'token': pref.getString('token').toString()
    });
    return getResponseFromApi(result);
  }

  Future fetchMedicineIntake(String selecteddate) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/getmedicineintakes?datetaken=$selecteddate';
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

  Future sendMedicineIntake(Map<String, dynamic> intakeData) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/savemedicineintake';
      var result = await http.post(Uri.parse(finalUrl),
          body: intakeData,
          headers: {'lang': lang, 'token': pref.getString('token').toString()});
      return getResponseFromApi(result);
    } catch (err) {
      throw Exception("Can't save medicine intake!" + err.toString());
    }
  }

  Future sendMessage(String message, String organization) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/sendmessage';
    var params = {'message': message.toString(), 'organization': organization};
    //print(params);
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

  Future setPatientProfilePhoto(File file) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/setpatientprofilephoto';
    var request = http.MultipartRequest("POST", Uri.parse(finalUrl));
    request.files.add(http.MultipartFile.fromBytes(
        'file', await file.readAsBytes(),
        filename: 'test.jpg'));
    request.headers
        .addAll({'lang': lang, 'token': pref.getString('token').toString()});
    var response = await request.send();
    var result = await http.Response.fromStream(response);
    return getResponseFromApi(result);
  }

  Future movePatientFile(int? fileId, String fileName, int folderId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/movepatientfile';
    var params = {
      'fileId': fileId.toString(),
      'fileName': fileName,
      'folderId': folderId.toString()
    };
    var result = await http.post(Uri.parse(finalUrl),
        body: params,
        headers: {'lang': lang, 'token': pref.getString('token').toString()});
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
    print(outPuts);
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
      print(finalUrl);
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

  Future changePassword(String userName, String newPassword, String oldPassword,
      String? deviceToken) async {
    String finalUrl = '$baseUrl/changepassword';
    var params = {
      'userName': userName,
      'newPassword': newPassword,
      'password': oldPassword,
      'deviceToken': deviceToken
    };
    var result = await http
        .post(Uri.parse(finalUrl), body: params, headers: {'lang': lang}); /**/
    return getResponseFromApi(result);
  }

  Future getSecretQuestion(String userName) async {
    String finalUrl = '$baseUrl/getsecretquestion?username=$userName';
    print(finalUrl);
    var result =
        await http.get(Uri.parse(finalUrl), headers: {'lang': lang}); /**/
    return getResponseFromApi(result);
  }

  Future onCheckAnswer(String answer, String userName) async {
    String finalUrl = '$baseUrl/oncheckanswer';
    var params = {'answer': answer, 'username': userName};
    print(params);
    var result = await http
        .post(Uri.parse(finalUrl), body: params, headers: {'lang': lang}); /**/
    return getResponseFromApi(result);
  }

  Future resetPasswordRequestEmail(String userName) async {
    String finalUrl = '$baseUrl/resetpasswordrequestemail?username=$userName';
    var result =
        await http.get(Uri.parse(finalUrl), headers: {'lang': lang}); /**/
    return getResponseFromApi(result);
  }

  Future resetPassword(String userName) async {
    String finalUrl = '$baseUrl/resetpassword';
    var params = {'username': userName};
    var result = await http
        .post(Uri.parse(finalUrl), body: params, headers: {'lang': lang}); /**/
    return getResponseFromApi(result);
  }

  Future setSecretQuestion(int? patientAnswerId, int? questionId,
      String? ownQuestion, String answer) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/setpatientsecretanswer';
    var params = {
      'ownquestion': ownQuestion.toString(),
      'answer': answer.toString()
    };
    print(params);
    if (patientAnswerId != null)
      params['patientanswerid'] = patientAnswerId.toString();

    if (questionId != null) params['secretquestionid'] = questionId.toString();

    var result = await http.post(Uri.parse(finalUrl), body: params, headers: {
      'lang': lang,
      'token': pref.getString('token').toString()
    }); /**/
    return getResponseFromApi(result);
  }

  Future getPatientRecipes() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/getpatientrecipes';
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

  Future getPatientDiagnoses() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/getpatientdiagnoselist';
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

  Future getPatientLibraryList(List<dynamic> params) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/getpatientlibrarylist';
      var body = {"patientGroups": jsonEncode(params)};
      var result = await http.post(Uri.parse(finalUrl),
          body: body,
          headers: {'lang': lang, 'token': pref.getString('token').toString()});
      return getResponseFromApi(result);
    } catch (err) {
      throw Exception("can't decode");
    }
  }

  Future deleteRequestByPatient() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl = '$baseUrl/deleterequestbypatient';
      var result = await http.get(Uri.parse(finalUrl),
          headers: {'lang': lang, 'token': pref.getString('token').toString()});
      return getResponseFromApi(result);
    } catch (err) {
      throw Exception("can't decode");
    }
  }

  Future extractdata() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String finalUrl =
          '$apiPublic/extractdata?token=${pref.getString('token')}';
      var result = await http.get(Uri.parse(finalUrl),
          headers: {'lang': lang, 'token': pref.getString('token').toString()});
      return getResponseFromApi(result);
    } catch (err) {
      throw Exception("can't decode");
    }
  }

  Future markAsRead(messageId) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      print(messageId);
      String finalUrl = '$baseUrl/markasread?messageid=$messageId';
      var result = await http.post(Uri.parse(finalUrl),
          headers: {'lang': lang, 'token': pref.getString('token').toString()});
      return getResponseFromApi(result);
    } catch (err) {
      throw Exception("can't decode");
    }
  }

  Future getnotificationhistories() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/getnotificationhistories';
    var result = await http.get(Uri.parse(finalUrl), headers: {
      'Content-Type': 'application/text',
      'lang': lang,
      'token': pref.getString('token').toString()
    });
    return getResponseFromApi(result);
  }

  Future patientrenewtoken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/patientrenewtoken';
    var result = await http.get(Uri.parse(finalUrl),
        headers: {'lang': lang, 'token': pref.getString('token').toString()});
    return getResponseFromApi(result);
  }

  Future getSearchFunctions(searchText) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/getsearchfunctions?searchText=$searchText';
    var result = await http.get(Uri.parse(finalUrl),
        headers: {'lang': lang, 'token': pref.getString('token').toString()});
    return getResponseFromApi(result);
  }

  Future getPatientSecretQuestions() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/getpatientsecretquestionlist';
    var result = await http.get(Uri.parse(finalUrl),
        headers: {'lang': lang, 'token': pref.getString('token').toString()});
    return getResponseFromApi(result);
  }

  Future getUnReadMessageCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/unreadmessagecount';
    var result = await http.get(Uri.parse(finalUrl),
        headers: {'lang': lang, 'token': pref.getString('token').toString()});
    return getResponseFromApi(result);
  }

  Future getLanguageList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/getlanguagelist';
    var result = await http.get(Uri.parse(finalUrl),
        headers: {'lang': lang, 'token': pref.getString('token').toString()});
    return getResponseFromApi(result);
  }

  Future setPatientLanguage(String language) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String finalUrl = '$baseUrl/setpatientlanguage?language=$language';
    var result = await http.post(Uri.parse(finalUrl),
        headers: {'lang': lang, 'token': pref.getString('token').toString()});
    return getResponseFromApi(result);
  }

  getResponseFromApi(http.Response result) async {
    try {
      if (result.headers['token'] != null) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('token', result.headers['token'].toString());
      }
      //  print(result.body);
      var body = jsonDecode(result.body);
      //  print(result.statusCode);
      if (result.statusCode == 200 || result.statusCode == 201) {
        try {
          return body;
        } on Exception catch (err) {
          showToast(AppLocalizations.tr(
              "Fehler bitte kontaktieren Sie den IT - Support"));
          throw Exception(AppLocalizations.tr(
              "Fehler bitte kontaktieren Sie den IT - Support"));
        }
      } else {
        body = jsonDecode(body);
        print("===================");
        //print(body['errors']);
        if (body['errors'] == null ||
            (body['errors'] != null &&
                (body['errors'] as List).first['error'] != 'expired'))
          showToast(AppLocalizations.tr(body['message']));

        if (body['message'] == "Bitte melden Sie sich erneut an.") {
          navigatorKey.currentState?.pushReplacementNamed("/login");
        }

        if (body['errors'][0] == "tokenexpired") {
          navigatorKey.currentState?.pushReplacementNamed("/login");
        }

        if (body['errors'] != null) {
          var firstError = (body['errors'] as List).first;
          throw (firstError);
        }

        throw Exception(body['message']);
      }
    } on Exception catch (err) {
      print(err.toString());
      showToast(err.toString());
      //showToast(AppLocalizations.tr("Something went wrong"));
      navigatorKey.currentState?.pushReplacementNamed("/login");
      throw Exception(AppLocalizations.tr(
          "Fehler bitte kontaktieren Sie den IT - Support"));
    }
  }
}
