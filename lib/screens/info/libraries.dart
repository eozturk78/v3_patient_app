import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:patient_app/apis/apis.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../colors/colors.dart';
import '../../model/library.dart';
import '../shared/bottom-menu.dart';
import '../shared/library-box.dart';
import '../shared/medication-plan-box.dart';

class LibraryListPage extends StatefulWidget {
  const LibraryListPage({super.key});

  @override
  State<LibraryListPage> createState() => _LibraryListPageState();
}

class _LibraryListPageState extends State<LibraryListPage> {
  Apis apis = Apis();
  List<Library> list = [];
  bool isStarted = true;
  @override
  void initState() {
    super.initState();
    getPatientLibraryList();
  }

  getPatientLibraryList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List params = jsonDecode(pref.getString("patientGroups")!);
    setState(() {
      isStarted = true;
    });
    apis.getPatientLibraryList(params).then((data) {
      setState(() {
        list = (data as List).map((e) => Library.fromJson(e)).toList();
        isStarted = false;
      });
    }, onError: (err) {
      setState(() {
        isStarted = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Bibliothek', context),
      body: SingleChildScrollView(
          child: Center(
              child: Padding(
        padding: EdgeInsets.all(15),
        child: isStarted
            ? CircularProgressIndicator(
                color: mainButtonColor,
              )
            : list.isEmpty
                ? Center(child: Text("no data found"))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    verticalDirection: VerticalDirection.down,
                    children: [
                      for (var item in list)
                        GestureDetector(
                          onTap: () async {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            await launch(
                                '${item.url}/${pref.getString('token')}');
                          },
                          child: CustomLibraryBox(item.title),
                        ),
                    ],
                  ),
      ))), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(3),
    );
  }
}
