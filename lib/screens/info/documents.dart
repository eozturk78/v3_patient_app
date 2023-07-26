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
import 'package:photo_view/photo_view.dart';
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
    getPatientFolders();
  }

  getPatientFolders() async {
    setState(() {
      isStarted = true;
    });
    apis.getPatientFolders().then(
      (value) {
        setState(() {
          isStarted = false;
          folderList = (value as List).map((e) => Folder.fromJson(e)).toList();
        });
      },
      onError: (err) => setState(
        () {
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
  int folderId = 1;
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
      }, onError: (err) {
        setState(() {
          isSendEP = false;
        });
      });
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalObjectKey<ExpandableFabState>(context);
    return Scaffold(
      appBar: leadingSubpage('Meine Dokumente!', context),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: isStarted
              ? CircularProgressIndicator(
                  color: mainButtonColor,
                )
              : folderList.isEmpty
                  ? Center(child: Text("no data found"))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Text(
                              "Hier können Sie Ihre ärztliche Dokumente ablegen und verwalten."),
                          SizedBox(
                            height: 15,
                          ),
                          for (var item in folderList)
                            GestureDetector(
                                onTap: () {
                                  onGotoFileScreen(item.id, item.folderName);
                                },
                                child: CustomDocumentBox(
                                    Icons.medication_outlined,
                                    item.folderName,
                                    item.fileCount)),
                        ],
                      ),
                    ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.

      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: key,
        distance: 60.0,
        type: ExpandableFabType.up,
        child: const Icon(Icons.add),
        overlayStyle: ExpandableFabOverlayStyle(
          blur: 2,
        ),
        onOpen: () {
          setState(() {
            selectedPhotoImage = null;
            selectedFile = null;
          });
          debugPrint('onOpen');
        },
        afterOpen: () {
          debugPrint('afterOpen');
        },
        onClose: () {
          debugPrint('onClose');
        },
        afterClose: () {
          debugPrint('afterClose');
        },
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
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
                    Navigator.pop(context, resp);
                  });
                });
              }
            },
            icon: new Icon(Icons.image_outlined),
            label: Text("Foto aufnehmen"),
          ),
          FloatingActionButton.extended(
            onPressed: () async {
              FilePickerResult? pickedFile =
                  await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowMultiple: false,
                allowedExtensions: ['jpg', 'pdf', 'doc'],
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
            },
            icon: new Icon(Icons.file_present_outlined),
            label: Text("Dokument / Foto hinzufügen"),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigatorBar(3),
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
                        child: Icon(Icons.close),
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
                              Navigator.pop(context, resp);
                            });
                          },
                          child: Icon(Icons.check))
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
                    document != null)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.84,
                    width: double.infinity,
                    child: PDFViewer(
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
            height: 400,
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
                        "KATEGORIE",
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
                        "BESCHREIBUNG",
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
                          setState(() {
                            isSendEP = true;
                          });
                          setPatientFile();
                        },
                        child: !isSendEP
                            ? const Text("Senden")
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
