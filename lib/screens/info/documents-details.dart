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
import 'package:patient_app/shared/toast.dart';
import 'package:permission_handler/permission_handler.dart';
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
    getFiles(true);
    getPatientFolders();
  }

  getFiles(bool loader) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      screenTitle = pref.getString("folderName")!;
      folderId = int.parse(pref.getString("folderId")!);
      isStarted = loader;
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
          getFiles(false);
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
      getFiles(false);
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
                        Text(sh.getLanguageResource("folder_is_empty"))
                      ],
                    ))
                  : SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        width: double.infinity,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          verticalDirection: VerticalDirection.down,
                          children: [
                            for (var item in fileList)
                              Column(children: [
                                TextButton(
                                  onPressed: () async {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Wrap(
                                          children: [
                                            ListTile(
                                              leading: Icon(
                                                  Icons.remove_red_eye_rounded),
                                              title: Text(
                                                  sh.getLanguageResource(
                                                      "show_file")),
                                              onTap: () {
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
                                                } else if (fileUrl
                                                    .contains('pdf')) {
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
                                            ),
                                            ListTile(
                                              leading: Icon(Icons.edit),
                                              title: Text(sh.getLanguageResource(
                                                  "edit_file_name_and_folder")),
                                              onTap: () {
                                                fileId = item.id;
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      onOpenFileInfo(context,
                                                          item.fileName),
                                                ).then((resp) {
                                                  setState(() {
                                                    getFiles(false);
                                                    screenTitle = resp;
                                                  });
                                                });
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: CustomDocumentBox(
                                      Icons.file_copy_rounded,
                                      item.fileName,
                                      null),
                                ),
                                Divider(
                                  height: 10,
                                )
                              ])
                          ],
                        ),
                      ),
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Wrap(
                children: [
                  ListTile(
                    leading: Icon(Icons.file_present_outlined),
                    title: Text(sh.getLanguageResource('add_document_photo')),
                    onTap: () async {
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
                                  openDialog2();
                                });
                              });
                            } else {
                              openDialog2();
                            }
                          });
                        }
                      }
                    },
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
                              builder: (context) => onOpenImage2(
                                context,
                              ),
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
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => onOpenFolderInfo(
                            context, screenTitle, folderId.toString()),
                      ).then((resp) {
                        setState(() {
                          screenTitle = resp;
                        });
                      });
                    },
                    leading: new Icon(Icons.edit),
                    title: Text(sh.getLanguageResource('rename_folder')),
                  ),
                  ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            onAreYouSureDeleteFolder(context, folderId),
                      ).then((resp) {
                        if (resp != null) Navigator.of(context).pop();
                      });
                    },
                    leading: new Icon(Icons.delete),
                    title: Text(sh.getLanguageResource('delete_folder')),
                  ),
                ],
              );
            },
          );
        },
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
                Text(sh.getLanguageResource('are_you_sure_delete_folder')),
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
                      child: Text(sh.getLanguageResource('no')),
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
                Text(sh.getLanguageResource('are_you_sure_delete_file')),
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
                      child: Text(sh.getLanguageResource('yes')),
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
                      child: Text(sh.getLanguageResource('no')),
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
                      child: Icon(
                        Icons.close,
                        size: 30,
                      ),
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
                      child: Icon(
                        Icons.delete_outline,
                        size: 30,
                      ),
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
                    tooltip: PDFViewerTooltip(
                        pick: sh.getLanguageResource('select_a_page')),
                    scrollDirection: Axis.vertical,
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
                          } else {
                            showToast(
                                sh.getLanguageResource('required_folder_name'));
                          }
                        },
                        child: !isSendEP
                            ? Text(sh.getLanguageResource('rename'))
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
                        sh.getLanguageResource('category'),
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
                        sh.getLanguageResource('description'),
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
                          print(fileId);
                          print(fileNameController.text);
                          print(folderId);
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
                        child: Icon(
                          Icons.close,
                          size: 30,
                        ),
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
}
