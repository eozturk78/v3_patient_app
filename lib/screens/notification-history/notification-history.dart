import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/apis.dart';
import '../../shared/shared.dart';
import '../shared/bottom-menu.dart';
import '../shared/shared.dart';

class NotificationHistoryPage extends StatefulWidget {
  const NotificationHistoryPage({super.key});
  @override
  State<NotificationHistoryPage> createState() => _NotificationHistoryPage();
}

class _NotificationHistoryPage extends State<NotificationHistoryPage> {
  Shared sh = Shared();
  Apis apis = Apis();
  bool isStarted = true;
  List<dynamic> listMessages = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _savedMessages();
  }

  _savedMessages() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.reload();
    setState(() {
      isStarted = false;
      if (pref.getString('messages') != null) {
        listMessages =
            (jsonDecode(pref.getString('messages')!) as List).reversed.toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingWithoutBack('Erinnerungen', context),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Center(
            child: SingleChildScrollView(
          child: isStarted
              ? CircularProgressIndicator(
                  color: mainButtonColor,
                )
              : listMessages!.isEmpty
                  ? Center(child: Text("no data found"))
                  : ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          listMessages![index]['isExpanded'] = !isExpanded;
                        });
                      },
                      children: [
                        for (var item in listMessages!)
                          ExpansionPanel(
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              return ListTile(
                                title: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.message,
                                      color: iconColor,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                        child: Text(
                                      item['title'],
                                      overflow: TextOverflow.ellipsis,
                                    ))
                                  ],
                                ),
                                subtitle: Text(item['date'].toString()),
                              );
                            },
                            body: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(item['message'] ?? ""),
                                ],
                              ),
                            ),
                            isExpanded: item['isExpanded'] ?? false,
                          )
                      ],
                    ),
        )),
      ),
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 0),
    );
  }
}
