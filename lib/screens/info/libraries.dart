import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:v3_patient_app/apis/apis.dart';
import 'package:v3_patient_app/screens/shared/list-box.dart';
import 'package:v3_patient_app/screens/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../colors/colors.dart';
import '../../model/library.dart';
import '../../shared/shared.dart';
import '../shared/bottom-menu.dart';
import '../shared/library-box.dart';
import '../shared/medication-plan-box.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class LibraryListPage extends StatefulWidget {
  const LibraryListPage({super.key});

  @override
  State<LibraryListPage> createState() => _LibraryListPageState();
}

class _LibraryListPageState extends State<LibraryListPage> {
  Apis apis = Apis();
  List<Library> list = [];
  bool isStarted = true;
  Shared sh = Shared();
  String token = "";
  @override
  void initState() {
    super.initState();
    getPatientLibraryList();
    sh.openPopUp(context, 'libraries');
  }

  getPatientLibraryList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString("token")!;
    List params = jsonDecode(pref.getString("patientGroups")!);
    setState(() {
      isStarted = true;
    });
    apis.getPatientLibraryList(params).then(
      (data) {
        setState(() {
          list = (data as List).map((e) => Library.fromJson(e)).toList();
          isStarted = false;
        });
      },
      onError: (err) {
        sh.redirectPatient(err, context);
        setState(
          () {
            isStarted = false;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage(sh.getLanguageResource('library'), context),
      body: SafeArea(
        // Wrap your body with SafeArea
        child: SingleChildScrollView(
          child: Center(
              child: Padding(
            padding: EdgeInsets.all(15),
            child: isStarted
                ? CircularProgressIndicator(
                    color: mainButtonColor,
                  )
                : list.isEmpty
                    ? Center(
                        child: Text(sh.getLanguageResource('no_data_found')))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          for (var item in list)
                            GestureDetector(
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) => onOpenImage2(
                                      context, '${item.url}/${token}'),
                                ).then((resp) {
                                  if (resp != null)
                                    Navigator.pop(context, resp);
                                });
                              },
                              child: CustomLibraryBox(item.title),
                            ),
                        ],
                      ),
          )),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      ////bottomNavigationBar: BottomNavigatorBar(selectedIndex: 4),
    );
  }
}

Widget onOpenImage2(BuildContext context, String url) {
  return AlertDialog(
    insetPadding: EdgeInsets.symmetric(
      horizontal: 0,
      vertical: 0,
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: 0,
      vertical: 0,
    ),
    content: StatefulBuilder(
      builder: (BuildContext context, setState) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.close,
                        size: 30,
                      ),
                    ),
                    Spacer()
                  ],
                ),
                height: 40,
                padding: EdgeInsets.only(right: 10, left: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: WebView(
                  initialUrl: url,
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              )
            ],
          ),
        );
      },
    ),
  );
}
