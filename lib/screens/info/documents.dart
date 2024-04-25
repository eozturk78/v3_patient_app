import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patient_app/apis/apis.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:patient_app/shared/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../colors/colors.dart';
import '../../model/folder.dart';
import '../../shared/shared.dart';
import '../shared/bottom-menu.dart';
import '../shared/document-box.dart';
import '../shared/library-box.dart';
import '../shared/medication-plan-box.dart';
import '../shared/profile-menu.dart';

class DocumentListPage extends StatefulWidget {
  const DocumentListPage({super.key});

  @override
  State<DocumentListPage> createState() => _DocumentListPageState();
}

class _DocumentListPageState extends State<DocumentListPage> {
  TextEditingController fileNameController = new TextEditingController();
  Shared sh = new Shared();

  Apis apis = Apis();
  List<Folder> folderList = [];
  bool isStarted = true;
  PlatformFile? selectedFile;
  XFile? selectedPhotoImage;
  String? path;
  bool pdfLoader = true;
  PDFDocument? document;
  bool isSendEP = false;
  @override
  void initState() {
    super.initState();
    getPatientFolders(true);
    sh.openPopUp(context, 'documents');
  }

  getPatientFolders(bool loader) async {
    setState(() {
      isStarted = loader;
    });
    apis.getPatientFolders().then(
      (value) {
        setState(() {
          isStarted = false;
          folderList = (value as List).map((e) => Folder.fromJson(e)).toList();
          folderId = folderList[0].id;
        });
      },
      onError: (err) => setState(
        () {
          sh.redirectPatient(err, context);
          isStarted = false;
        },
      ),
    );
  }

  openDialog() {
    showDialog(
      context: context,
      builder: (context) => onOpenImage(
        context,
      ),
    );
  }

  String fileName = "";
  late int folderId;
  setPatientFile() {
    File? file;
    if (selectedPhotoImage == null && selectedFile != null) {
      file = File(selectedFile!.path!);
    }
    if (selectedPhotoImage != null) file = File(selectedPhotoImage!.path!);
    setState(() {
      isSendEP = true;
    });
    if (file != null) {
      apis.setPatientFile(file, fileNameController.text, folderId).then(
        (value) {
          var folderName =
              folderList.where((x) => x.id == folderId)?.first?.folderName;
          setState(() {
            isSendEP = false;
          });
          onGotoFileScreen(folderId, folderName!);
        },
        onError: (err) {
          sh.redirectPatient(err, context);
          setState(
            () {
              isSendEP = false;
            },
          );
        },
      );
    }
  }

  onGotoFileScreen(int folderId, String folderName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('folderId', folderId.toString());
    pref.setString('folderName', folderName);
    Navigator.of(context).pushNamed('/document-details').then((value) {
      setState(() {
        isSendEP = false;
      });
    }).then((value) {
      getPatientFolders(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalObjectKey<ExpandableFabState>(context);
    return Scaffold(
      appBar: leadingSubpage(sh.getLanguageResource('my_documents'), context),
      body: SafeArea(
        // Wrap your body with SafeArea
        child: Center(
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width *
                ResponsiveValue(
                  context,
                  defaultValue: 1,
                  conditionalValues: [
                    Condition.largerThan(
                      //Tablet
                      name: MOBILE,
                      value: 0.5,
                    ),
                  ],
                ).value!,
            child: isStarted
                ? CircularProgressIndicator(
                    color: mainButtonColor,
                  )
                : folderList.isEmpty
                    ? Center(
                        child: Text(sh.getLanguageResource('no_data_found')))
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        width: double.infinity,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            verticalDirection: VerticalDirection.down,
                            children: [
                              for (var item in folderList)
                                Column(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        onGotoFileScreen(
                                            item.id, item.folderName);
                                      },
                                      style: profileBtnStyle,
                                      child: CustomDocumentBox(
                                        Icons.medication_outlined,
                                        item.folderName,
                                        item.fileCount,
                                      ),
                                    ),
                                    Divider(
                                      height: 10,
                                    )
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.

      //floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Wrap(
                children: [
                  ListTile(
                    onTap: () async {
                      setState(() {
                        showDialog(
                          context: context,
                          builder: (context) => onOpenFolderInfo(context),
                        ).then((resp) {
                          getPatientFolders(false);
                        });
                      });
                    },
                    leading: new Icon(Icons.file_present_outlined),
                    title: Text(sh.getLanguageResource('new_folder')),
                  ),
                  ListTile(
                    onTap: () async {
                      if (await sh.checkPermission(context, Permission.camera,
                              sh.cameraPermissionText) ==
                          true) {
                        XFile? pickedFile = await ImagePicker().pickImage(
                          source: ImageSource.camera,
                        );
                        if (pickedFile != null) {
                          setState(() {
                            selectedPhotoImage = pickedFile;
                            showDialog(
                              context: context,
                              builder: (context) => onOpenImage(context),
                            ).then((resp) {
                              if (resp != null) Navigator.pop(context, resp);
                            });
                          });
                        }
                      }
                    },
                    leading: new Icon(Icons.image_outlined),
                    title: Text(sh.getLanguageResource('take_a_photo')),
                  ),
                  ListTile(
                    onTap: () async {
                      if (await sh.checkPermission(context, Permission.storage,
                              sh.storagePermissionText) ==
                          true) {
                        FilePickerResult? pickedFile =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowMultiple: false,
                          allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],
                        );
                        if (pickedFile != null) {
                          setState(() {
                            selectedFile = pickedFile!.files.first;
                            if (selectedFile?.extension == 'pdf') {
                              File file = File(selectedFile!.path!);
                              PDFDocument.fromFile(file).then((value) {
                                setState(() {
                                  document = value;
                                  openDialog();
                                });
                              });
                            } else {
                              openDialog();
                            }
                          });
                        }
                      }
                    },
                    leading: new Icon(Icons.file_present_outlined),
                    title: Text(sh.getLanguageResource('add_document_photo')),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 4),
    );
  }

  Widget onOpenImage(BuildContext context) {
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
                      Spacer(),
                      TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => onOpenFileInfo(
                                context,
                              ),
                            ).then((resp) {
                              if (resp != null) Navigator.pop(context, resp);
                            });
                          },
                          child: Icon(
                            Icons.check,
                            size: 30,
                          ))
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
                SizedBox(
                  height: 10,
                ),
                if (selectedFile?.extension == 'jpg' ||
                    selectedFile?.extension == 'jpeg' ||
                    selectedFile?.extension == 'png' ||
                    selectedFile?.extension == 'Webp' ||
                    selectedPhotoImage != null)
                  Flexible(
                    flex: 2,
                    child: Image.file(
                      selectedPhotoImage == null
                          ? File(selectedFile!.path!)
                          : File(selectedPhotoImage!.path!),
                      width: MediaQuery.of(context).size.width * 1,
                      height: double.infinity,
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return const Center(
                            child: Text('This image type is not supported'));
                      },
                    ),
                  ),
                if (selectedPhotoImage == null &&
                    selectedFile?.extension != 'jpg' &&
                    selectedFile?.extension != 'jpeg' &&
                    selectedFile?.extension != 'png' &&
                    selectedFile?.extension != 'Webp' &&
                    document != null)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.84,
                    width: double.infinity,
                    child: PDFViewer(
                      scrollDirection: Axis.vertical,
                      document: document!,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget onOpenFileInfo(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 0,
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sh.getLanguageResource('storage_location'),
                        style: labelText,
                      ),
                      if (folderList.isNotEmpty)
                        SizedBox(
                          height: 40,
                          child: DropdownButton<int>(
                            isExpanded: true,
                            underline: SizedBox(),
                            alignment: Alignment.bottomRight,
                            borderRadius: BorderRadius.circular(15),
                            value: folderId,
                            onChanged: (value) {
                              setState(() {
                                if (value != null) folderId = value;
                              });
                            },
                            items: folderList
                                .map((item) => DropdownMenuItem(
                                      child: Text(
                                        item.folderName,
                                      ),
                                      value: item.id,
                                    ))
                                .toList(),
                          ),
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        sh.getLanguageResource('name_of_document'),
                        style: labelText,
                      ),
                      TextFormField(
                        controller: fileNameController,
                        obscureText: false,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        validator: (text) => sh.textValidator(text),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          primary: mainButtonColor,
                        ),
                        onPressed: () {
                          if (fileNameController.text != "") {
                            setState(() {
                              isSendEP = true;
                            });
                            setPatientFile();
                          } else {
                            showToast(
                                sh.getLanguageResource('enter_your_file_name'));
                          }
                        },
                        child: !isSendEP
                            ? Text(sh.getLanguageResource('send'))
                            : Transform.scale(
                                scale: 0.5,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                )),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget onOpenFolderInfo(BuildContext context) {
    TextEditingController folderNameController = new TextEditingController();
    Shared sh = Shared();
    bool isSendEP = false;
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 0,
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sh.getLanguageResource('name_of_the_folder')),
                      TextFormField(
                        controller: folderNameController,
                        obscureText: false,
                        validator: (text) => sh.textValidator(text),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          primary: mainButtonColor,
                        ),
                        onPressed: () {
                          if (folderNameController.text != "") {
                            setState(() {
                              isSendEP = true;
                            });
                            apis
                                .setPatientFolderName(
                                    null, folderNameController.text)
                                .then(
                              (resp) {
                                setState(() {
                                  isSendEP = false;
                                });
                                Navigator.of(context)
                                    .pop(folderNameController.text);
                              },
                              onError: (err) {
                                sh.redirectPatient(err, context);
                                setState(
                                  () {
                                    isSendEP = false;
                                  },
                                );
                              },
                            );
                          } else {
                            showToast(
                                sh.getLanguageResource('required_folder_name'));
                          }
                        },
                        child: !isSendEP
                            ? Text(sh.getLanguageResource('create'))
                            : Transform.scale(
                                scale: 0.5,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                )),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
