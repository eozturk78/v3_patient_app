import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/apis/apis.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/message-list-container.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:patient_app/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../colors/colors.dart';
import '../shared/bottom-menu.dart';
import '../shared/message-text-bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class Message {
  String? image;
  String text;
  String dateTime;
  String senderTitle;
  int senderType;
  Message(
      {required this.text,
      required this.senderType,
      required this.senderTitle,
      required this.dateTime,
      this.image});
}

class _ChatPageState extends State<ChatPage> {
  late String thread;
  List<Message> listMessages = [];
  Apis apis = Apis();
  Shared sh = Shared();
  bool isStarted = true;
  ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
    getThreadMessages();
  }

  getThreadMessages() async {
    setState(() {
      isStarted = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    apis.getPatientThreadMessages(pref.getString("thread") ?? "").then((value) {
      setState(() {
        for (var element in value) {
          if (element['body'] != null) {
            listMessages.add(Message(
                text: element['body'],
                senderType:
                    element['sender']['type'] == "organization" ? 10 : 20,
                senderTitle: element['sender']['name'],
                dateTime: sh.formatDate(element['timestamp'])));
          }

          listMessages.sort(((a, b) => b.dateTime.compareTo(a.dateTime)));
        }
        setState(() {
          isStarted = false;
        });
      });
    }, onError: (err) {
      setState(() {
        isStarted = false;
      });
    });
  }

  _scrollToEnd() {
    controller.animateTo(
      controller.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    return Scaffold(
      appBar: leadingSubpage('Nachrichten!', context),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: isStarted
            ? CircularProgressIndicator(
                color: mainButtonColor,
              )
            : listMessages.isEmpty
                ? Center(child: Text("no data found"))
                : Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: SingleChildScrollView(
                      controller: controller,
                      child: ListView.builder(
                          itemCount: listMessages?.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return CustomMessageTextBubble(
                              dateTime: listMessages[index].dateTime,
                              senderTitle:
                                  listMessages[index].senderTitle ?? "",
                              text: listMessages[index].text,
                              senderType: listMessages[index].senderType,
                              image: null,
                              messageType: 20,
                            );
                          }),
                    ),
                  ),
      ),
      floatingActionButton: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 30),
        child: TextFormField(
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Message',
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min, // added line
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.image_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigatorBar(1),
    );
  }
}
