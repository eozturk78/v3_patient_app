import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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

import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class Message {
  String? image;
  String? text;
  String dateTime;
  String senderTitle;
  int senderType;
  int index;
  Message(
      {this.text,
      required this.senderType,
      required this.senderTitle,
      required this.dateTime,
      this.image,
      required this.index});
}

class _ChatPageState extends State<ChatPage> {
  late String thread;
  List<Message> listMessages = [];
  Apis apis = Apis();
  Shared sh = Shared();
  bool isStarted = true;
  ScrollController controller = ScrollController();
  TextEditingController txtMessageController = TextEditingController();
  TextEditingController txtHeaderMessageController = TextEditingController();
  bool loaderSendMessage = false;
  late String organization = "";
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
    organization = pref.getString("organization")!;
    apis.getPatientThreadMessages(pref.getString("thread") ?? "").then((value) {
      setState(() {
        var i = 0;
        for (var element in value) {
          if (element['body'] != null) {
            listMessages.add(Message(
                image: element['links'] != null &&
                        element['links']['attachments']?.length > 0
                    ? element['links']['attachments'][0]['full']
                    : null,
                text: element['body'],
                senderType:
                    element['sender']['type'] == "organization" ? 10 : 20,
                senderTitle: element['sender']['name'],
                dateTime: sh.formatDateTime(element['timestamp']),
                index: i));
            i++;
          }
        }
        listMessages.sort((a, b) => b.index.compareTo(a.index));
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
            ? const Center(
                child: CircularProgressIndicator(
                  color: mainButtonColor,
                ),
              )
            : listMessages.isEmpty
                ? Center(child: Text("no data found"))
                : Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: SingleChildScrollView(
                      controller: controller,
                      child: ListView.builder(
                          itemCount: listMessages?.length,
                          physics: const ScrollPhysics(), // new
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return CustomMessageTextBubble(
                              dateTime: listMessages[index].dateTime,
                              senderTitle:
                                  listMessages[index].senderTitle ?? "",
                              text: listMessages[index].text ?? "",
                              senderType: listMessages[index].senderType,
                              image: listMessages[index].image,
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
          controller: txtMessageController,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Message',
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min, // added line
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.image_outlined),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => onChoosePhotoOption(context),
                    ).then((resp) {
                      selectedFile = null;
                      listMessages.add(Message(
                          image: resp['links'] != null &&
                                  resp['links']['attachments']?.length > 0
                              ? resp['links']['attachments'][0]['full']
                              : null,
                          text: resp['body'],
                          senderType: 20,
                          senderTitle: resp['sender']['name'],
                          dateTime: sh.formatDateTime(resp['timestamp']),
                          index:
                              listMessages[listMessages.length - 1].index - 1));
                      listMessages.sort((a, b) => b.index.compareTo(a.index));
                      FocusScope.of(context).unfocus();
                    });
                  },
                ),
                IconButton(
                  icon: loaderSendMessage == false
                      ? Icon(Icons.send)
                      : CircularProgressIndicator(),
                  onPressed: () {
                    setState(() {
                      loaderSendMessage = true;
                    });
                    apis
                        .sendMessage(txtMessageController.text, organization)
                        .then((resp) {
                      txtMessageController.text = "";
                      setState(
                        () {
                          listMessages.add(Message(
                              image: resp['links'] != null &&
                                      resp['links']['attachments']?.length > 0
                                  ? resp['links']['attachments'][0]['full']
                                  : null,
                              text: resp['body'],
                              senderType: 20,
                              senderTitle: resp['sender']['name'],
                              dateTime: sh.formatDateTime(resp['timestamp']),
                              index:
                                  listMessages[listMessages.length - 1].index -
                                      1));
                          listMessages
                              .sort((a, b) => b.index.compareTo(a.index));
                          listMessages.forEach((element) {
                            print(element.index);
                          });

                          loaderSendMessage = false;
                          FocusScope.of(context).unfocus();
                          txtMessageController.clear();
                          controller.animateTo(
                            controller.position.maxScrollExtent,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 1),
                          );
                        },
                      );
                    }, onError: (err) {
                      setState(() {
                        loaderSendMessage = false;
                      });
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigatorBar(1),
    );
  }

  XFile? selectedFile;

  Widget onChoosePhotoOption(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(0),
      content: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        XFile? pickedFile = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile != null) {
                          setState(() {
                            selectedFile = pickedFile;
                            showDialog(
                              context: context,
                              builder: (context) => onChosenPhoto(context),
                            ).then((resp) {
                              Navigator.pop(context, resp);
                            });
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: 200,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(183, 255, 255, 255),
                        ),
                        child:  Column(
                          children: [
                            Icon(Icons.image),
                            Text("Take From Galery")
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () async {
                        XFile? pickedFile = await ImagePicker().pickImage(
                          source: ImageSource.camera,
                        );
                        if (pickedFile != null) {
                          setState(() {
                            selectedFile = pickedFile;
                            showDialog(
                              context: context,
                              builder: (context) => onChosenPhoto(context),
                            ).then((resp) {
                              Navigator.pop(context, resp);
                            });
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: 200,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(183, 255, 255, 255),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.camera_alt_outlined),
                            Text("Take a photo"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  ScrollController controller2 = ScrollController();

  _scrollToEnd2() {
    controller2.animateTo(
      controller2.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 1),
    );
  }

  Widget onChosenPhoto(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd2());
    return AlertDialog(
      backgroundColor: Colors.black,
      insetPadding: const EdgeInsets.all(0),
      actionsPadding: EdgeInsets.all(0),
      content: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Container(
            height: double.infinity,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(0),
              controller: controller2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: GestureDetector(
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Center(
                      child: Image.file(
                        File(selectedFile!.path),
                        width: MediaQuery.of(context).size.width * 1,
                        height: 400,
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return const Center(
                              child: Text('This image type is not supported'));
                        },
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: txtHeaderMessageController,
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 42, 43, 44),
                      hintText: 'Header of your attachment',
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min, // added line
                        children: <Widget>[
                          IconButton(
                            icon: loaderSendMessage == false
                                ? Icon(Icons.send)
                                : CircularProgressIndicator(),
                            onPressed: () {
                              selectedFile!.readAsBytes().then((value) {
                                setState(
                                  () {
                                    loaderSendMessage = true;
                                  },
                                );
                                apis
                                    .sendMessageWithAttachment(
                                        txtHeaderMessageController.text,
                                        base64Encode(value),
                                        organization)
                                    .then((resp) {
                                  selectedFile = null;
                                  loaderSendMessage = false;
                                  txtHeaderMessageController.clear();
                                  Navigator.pop(context, resp);
                                }, onError: (err) {
                                  setState(
                                    () {
                                      loaderSendMessage = true;
                                    },
                                  );
                                });
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Timer(
                        Duration(milliseconds: 200),
                        () {
                          controller2.animateTo(controller2.position.pixels,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut);
                        },
                      );
                    },
                    obscureText: false,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
