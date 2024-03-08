import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:patient_app/apis/apis.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/message-list-container.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:patient_app/shared/shared.dart';
import 'package:patient_app/shared/toast.dart';
import 'package:permission_handler/permission_handler.dart';
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
  String? messageId;
  String dateTime;
  String senderTitle;
  String? readAt;
  int senderType;
  int index;
  Message(
      {this.text,
      required this.senderType,
      required this.senderTitle,
      required this.messageId,
      required this.dateTime,
      this.readAt,
      this.image,
      required this.index});
}

class _ChatPageState extends State<ChatPage> {
  late String thread;
  List<Message> listMessages = [];
  Apis apis = Apis();
  Shared sh = Shared();
  bool isStarted = false;
  ScrollController controller = ScrollController();
  TextEditingController txtMessageController = TextEditingController();
  TextEditingController txtHeaderMessageController = TextEditingController();
  bool loaderSendMessage = false;
  late String organization = "";
  @override
  void initState() {
    super.initState();
    getThreadMessages();

    controller = new ScrollController()..addListener(_scrollListener);
  }

  getThreadMessages() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.getString('defaultMsg') != null)
      txtMessageController.text = pref.getString('defaultMsg')!;
    pref.remove('defaultMsg');
    organization = pref.getString("organization")!;
    if (pref.getString("thread") != null) {
      setState(() {
        isStarted = true;
      });
      apis.getPatientThreadMessages(pref.getString("thread") ?? "").then(
          (value) {
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
                  readAt: element['readAt'],
                  messageId: element['links'] != null
                      ? sh.getBaseName(element['links']['message'])
                      : null,
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
        sh.redirectPatient(err, context);
        setState(() {
          isStarted = false;
        });
      });
    }
  }

  _scrollToEnd() {
    if (scrollToEnd)
      controller.animateTo(
        controller.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 1),
      );
  }

  bool scrollToEnd = true;
  int itemLength = 16;
  _scrollListener() {
    if (controller.offset == 0.0) {
      setState(() {
        scrollToEnd = false;
        if (listMessages.length > itemLength) {
          if (listMessages.length - itemLength > 10) {
            itemLength = itemLength + 10;
            Future.delayed(const Duration(milliseconds: 100), () {
              setState(() {
                controller.animateTo(2,
                    duration: Duration(milliseconds: 100), curve: Curves.ease);
              });
            });
          } else
            itemLength = listMessages.length;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    return Scaffold(
      appBar: leadingSubpage('Nachrichten', context),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: isStarted
                ? const Center(
                    child: CircularProgressIndicator(
                      color: mainButtonColor,
                    ),
                  )
                : listMessages.isEmpty
                    ? Center(child: Text("Keine Daten gefunden"))
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: SingleChildScrollView(
                          controller: controller,
                          child: ListView.builder(
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return (listMessages.length - 1) - index > -1
                                  ? CustomMessageTextBubble(
                                      dateTime: listMessages[index].dateTime,
                                      senderTitle:
                                          listMessages[index].senderTitle ?? "",
                                      text: listMessages[index].text ?? "",
                                      senderType:
                                          listMessages[index].senderType,
                                      readAt: listMessages[index].readAt,
                                      image: listMessages[index].image,
                                      messageId:
                                          listMessages[index].messageId ?? "",
                                      messageType: 20,
                                    )
                                  : null;
                            },
                          ),
                        ),
                      ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 1,
              padding: EdgeInsets.only(left: 10),
              child: TextFormField(
                controller: txtMessageController,
                obscureText: false,
                keyboardType: TextInputType.multiline,
                minLines: 1, //Normal textInputField will be displayed
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Nachrichten',
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min, // added line
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.camera_alt_outlined),
                        onPressed: () async {
                          if (await sh.checkPermission(context,
                                  Permission.camera, sh.cameraPermissionText) ==
                              true) {
                            XFile? pickedFile = await ImagePicker().pickImage(
                              source: ImageSource.camera,
                            );
                            if (pickedFile != null) {
                              uploadFile(pickedFile);
                            }
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.image_outlined),
                        onPressed: () async {
                          if ((Platform.isIOS &&
                                      await sh.checkPermission(
                                          context,
                                          Permission.photos,
                                          sh.galeryPermissionText) ||
                                  (Platform.isAndroid &&
                                      await sh.checkPermission(
                                          context,
                                          Permission.storage,
                                          sh.galeryPermissionText))) ==
                              true) {
                            XFile? pickedFile = await ImagePicker().pickImage(
                              source: ImageSource.gallery,
                            );
                            if (pickedFile != null) {
                              uploadFile(pickedFile);
                            }
                          }
                        },
                      ),
                      IconButton(
                        icon: loaderSendMessage == false
                            ? Icon(Icons.send)
                            : CircularProgressIndicator(),
                        onPressed: () {
                          if (txtMessageController.text != "") {
                            setState(() {
                              loaderSendMessage = true;
                            });
                            apis
                                .sendMessage(
                                    txtMessageController.text, organization)
                                .then((resp) {
                              print(resp);
                              txtMessageController.text = "";
                              setState(
                                () {
                                  var index = 0;
                                  if (listMessages.isNotEmpty)
                                    index =
                                        listMessages[listMessages.length - 1]
                                                .index -
                                            1;
                                  listMessages.add(Message(
                                      image: resp['links'] != null &&
                                              resp['links']['attachments']
                                                      ?.length >
                                                  0
                                          ? resp['links']['attachments'][0]
                                              ['full']
                                          : null,
                                      messageId: resp['links'] != null
                                          ? sh.getBaseName(
                                              resp['links']['message'])
                                          : null,
                                      text: resp['body'],
                                      senderType: 20,
                                      senderTitle: resp['sender']['name'],
                                      dateTime:
                                          sh.formatDateTime(resp['timestamp']),
                                      index: index));
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
                              sh.redirectPatient(err, context);
                              setState(() {
                                loaderSendMessage = false;
                              });
                            });
                          } else {
                            showToast(
                                "Bitte Text einfügen um Nachricht zu senden");
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 3),
    );
  }

  uploadFile(XFile pickedFile) {
    setState(() {
      selectedFile = pickedFile;
      showDialog(
        context: context,
        builder: (context) => onChosenPhoto(context),
      ).then((resp) {
        selectedFile = null;
        var index = listMessages[listMessages.length - 1].index - 1;
        setState(() {
          listMessages.add(Message(
              image: resp['links'] != null &&
                      resp['links']['attachments']?.length > 0
                  ? resp['links']['attachments'][0]['full']
                  : null,
              text: resp['body'],
              senderType: 20,
              senderTitle: resp['sender']['name'],
              dateTime: sh.formatDateTime(resp['timestamp']),
              messageId: resp['links'] != null
                  ? sh.getBaseName(resp['links']['message'])
                  : null,
              index: index));
        });
        listMessages.sort((a, b) => b.index.compareTo(a.index));
        FocusScope.of(context).unfocus();
      });
    });
  }

  XFile? selectedFile;

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
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
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
            child: Scaffold(
              backgroundColor: Colors.black,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.81,
                      child: Image.file(
                        File(selectedFile!.path),
                        fit: BoxFit.contain,
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return const Center(
                              child: Text('This image type is not supported'));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: Container(
                margin: EdgeInsets.only(left: 30),
                child: TextFormField(
                  controller: txtHeaderMessageController,
                  style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255)),
                  decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 0, 0, 0),
                    hintText: 'Nachricht',
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(255, 207, 207, 207),
                    ),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 158, 158, 158),
                        width: 0.3,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 158, 158, 158),
                        width: 0.3,
                      ),
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min, // added line
                      children: <Widget>[
                        IconButton(
                          icon: loaderSendMessage == false
                              ? Icon(Icons.send)
                              : CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                          color: Colors.white,
                          onPressed: () {
                            setState(
                              () {
                                loaderSendMessage = true;
                              },
                            );
                            selectedFile!.readAsBytes().then((value) {
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
                                sh.redirectPatient(err, context);
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
                  obscureText: false,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
