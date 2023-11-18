import 'dart:async';
import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../apis/apis.dart';
import '../../model/patient-file.dart';
import '../../model/folder.dart';
import '../../shared/shared.dart';
import '../shared/bottom-menu.dart';
import '../shared/document-box.dart';
import '../shared/library-box.dart';
import '../shared/medication-plan-box.dart';
import '../shared/profile-menu.dart';

class DocumentDetailsPage extends StatefulWidget {
  const DocumentDetailsPage({super.key});

  @override
  State<DocumentDetailsPage> createState() => _DocumentDetailsPageState();
}

class _DocumentDetailsPageState extends State<DocumentDetailsPage> {
  TextEditingController fileNameController = new TextEditingController();
  late String screenTitle;
  late int folderId;
  Apis apis = Apis();
  List<PatientFile> fileList = [];
  bool isStarted = true;
  PDFDocument? document;
  String? imageUrl;
  bool isPdf = false;
  List<Folder> folderList = [];
  bool isSendEP = false;
  Shared sh = Shared();

  XFile? selectedPhotoImage;
  PlatformFile? selectedFile;
  @override
  void initState() {
    super.initState();
    getFiles();
  }

  getFiles() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      screenTitle = pref.getString("folderName")!;
      folderId = int.parse(pref.getString("folderId")!);
      isStarted = true;
      Apis apis = Apis();
      apis.getPatientFiles(folderId).then(
            (value) => {
              setState(() {
                isStarted = false;
                print(value);
                fileList = (value as List)
                    .map((e) => PatientFile.fromJson(e))
                    .toList();
              })
            },
            onError: (err) => setState(
              () {
                sh.redirectPatient(err, context);
                isStarted = false;
              },
            ),
          );
    });
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
          //print(folderList);
          folderId = folderId;
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
          Navigator.of(context).pop('ok');
          getFiles();
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

  int? fileId;
  openDialog(PatientFile? file) {
    fileId = file?.id;
    getPatientFolders();
    showDialog(
      context: context,
      builder: (context) => onOpenImage(context, file?.fileName),
    ).then((value) {
      getFiles();
    });
  }

  openDialog2() {
    getPatientFolders();
    showDialog(
      context: context,
      builder: (context) => onOpenImage2(
        context,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalObjectKey<ExpandableFabState>(context);
    return Scaffold(
      appBar: leadingSubpage(screenTitle, context),
      body: Center(
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
          child: Padding(
            padding: EdgeInsets.all(15),
            child: isStarted
                ? CircularProgressIndicator(
                    color: mainButtonColor,
                  )
                : fileList.isEmpty
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/empty-folder.png",
                            width: 200,
                            height: 100,
                          ),
                          Text("Ordner ist leer")
                        ],
                      ))
                    : SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            verticalDirection: VerticalDirection.down,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              for (var item in fileList)
                                Column(children: [
                                  TextButton(
                                      onPressed: () async {
                                        var fileUrl = "";

                                        fileUrl =
                                            '${apis.apiPublic}/patient_files/${item.fileUrl}';

                                        if (item.fileUrl
                                            .contains('treatmentid')) {
                                          var url =
                                              '${apis.apiPublic}/${item.fileUrl}';
                                          PDFDocument.fromURL(url)
                                              .then((value) {
                                            setState(() {
                                              isPdf = true;
                                              document = value;
                                              openDialog(item);
                                            });
                                          });
                                        } else if (fileUrl.contains('pdf')) {
                                          PDFDocument.fromURL(fileUrl)
                                              .then((value) {
                                            setState(() {
                                              isPdf = true;
                                              document = value;
                                              openDialog(item);
                                            });
                                          });
                                        } else {
                                          setState(() {
                                            isPdf = false;
                                            imageUrl = fileUrl;
                                            openDialog(item);
                                          });
                                        }
                                      },
                                      child: CustomDocumentBox(
                                          Icons.file_copy_rounded,
                                          item.fileName,
                                          null)),
                                  Divider()
                                ])
                            ],
                          ),
                        ),
                      ),
          ),
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: key,
        distance: 60.0,
        type: ExpandableFabType.up,
        child: const Icon(
          Icons.add,
          color: mainButtonColor,
        ),
        backgroundColor: Colors.white,
        overlayStyle: ExpandableFabOverlayStyle(
          blur: 2,
        ),
        onOpen: () {
          setState(() {});
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
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) =>
                    onAreYouSureDeleteFolder(context, folderId),
              ).then((resp) {
                if (resp != null) Navigator.of(context).pop();
              });
            },
            icon: new Icon(Icons.delete),
            label: Text("Ordner löschen"),
          ),
          FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) =>
                    onOpenFolderInfo(context, screenTitle, folderId.toString()),
              ).then((resp) {
                setState(() {
                  screenTitle = resp;
                });
              });
            },
            icon: new Icon(Icons.edit),
            label: Text("Ordner umbenennen"),
          ),
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
                    builder: (context) => onOpenImage2(
                      context,
                    ),
                  ).then((resp) {
                    if (resp != null) Navigator.pop(context, resp);
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
                        openDialog2();
                      });
                    });
                  } else {
                    openDialog2();
                  }
                });
              }
            },
            icon: new Icon(Icons.file_present_outlined),
            label: Text("Dokument / Foto hinzufügen"),
          ),
        ],
      ),
    );
  }

  Widget onAreYouSureDeleteFolder(BuildContext context, int folderId) {
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
            width: MediaQuery.of(context).size.width * 0.6,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Sind Sie sicher, dass Sie den Ordner löschen wollen?"),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: mainButtonColor,
                      ),
                      onPressed: () {
                        apis
                            .deletePatientFolder(folderId)
                            .then((resp) => {Navigator.of(context).pop("ok")});
                      },
                      child: Text("Ja"),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Nein"),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget onAreYouSureDeleteFile(BuildContext context, int? fileId) {
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
            width: MediaQuery.of(context).size.width * 0.6,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Sind Sie sicher, dass Sie die Datei löschen wollen?"),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: mainButtonColor,
                      ),
                      onPressed: () {
                        apis.deletePatientFile(fileId!).then((resp) {
                          Navigator.of(context).pop('ok');
                        });
                      },
                      child: Text("Ja"),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Nein"),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget onOpenImage(BuildContext context, String? fileName) {
    String? _fileName = fileName ?? null;
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
            child: Column(children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.close),
                    ),
                    TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                onOpenFileInfo(context, _fileName),
                          ).then((value) {
                            print(value);
                            _fileName = value;
                            if (value != null) Navigator.of(context).pop();
                          });
                        },
                        child: Text(_fileName ?? "")),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              onAreYouSureDeleteFile(context, fileId),
                        ).then((resp) {
                          if (resp != null) Navigator.of(context).pop();
                        });
                      },
                      child: Icon(Icons.delete_outline),
                    ),
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
              if (isPdf)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.84,
                  width: double.infinity,
                  child: PDFViewer(
                    document: document!,
                  ),
                ),
              if (!isPdf && imageUrl != null)
                Flexible(
                    child: AspectRatio(
                  aspectRatio: 0.7,
                  child: PhotoViewGallery.builder(
                    backgroundDecoration: BoxDecoration(color: Colors.white),
                    scrollPhysics: BouncingScrollPhysics(),
                    builder: (BuildContext context, int index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage(imageUrl!),
                        initialScale: PhotoViewComputedScale.contained * 0.8,
                        minScale: PhotoViewComputedScale.contained * 0.8,
                      );
                    },
                    itemCount: 1,
                  ),
                ))
            ]),
          );
        },
      ),
    );
  }

  Widget onOpenFolderInfo(
      BuildContext context, String folderName, String folderId) {
    TextEditingController folderNameController = new TextEditingController();
    folderNameController.text = folderName;
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
                      Text("Name des Ordners"),
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
                          setState(() {
                            isSendEP = true;
                          });
                          apis
                              .setPatientFolderName(
                                  folderId, folderNameController.text)
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

  Widget onOpenFileInfo(BuildContext context, String? fileName) {
    TextEditingController fileNameController = new TextEditingController();
    fileNameController.text = fileName ?? "";
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
                          apis
                              .movePatientFile(
                                  fileId, fileNameController.text, folderId)
                              .then(
                            (data) {
                              Navigator.of(context)
                                  .pop(fileNameController.text);
                              setState(() {
                                isSendEP = false;
                              });
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

  Widget onOpenImage2(BuildContext context) {
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
                            getPatientFolders();
                            showDialog(
                              context: context,
                              builder: (context) => onOpenFileInfo2(
                                context,
                              ),
                            ).then((resp) {
                              if (resp != null) Navigator.pop(context, resp);
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

  Widget onOpenFileInfo2(BuildContext context) {
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
                        "Speicherort",
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
                        "Name des Dokuments",
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
