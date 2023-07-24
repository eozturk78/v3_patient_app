import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patient_app/apis/apis.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../colors/colors.dart';
import '../../model/folder.dart';
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
  Apis apis = Apis();
  List<Folder> folderList = [];
  bool isStarted = true;
  XFile? selectedFile;
  @override
  void initState() {
    super.initState();
    getPatientFolders();
  }

  getPatientFolders() async {
    setState(() {
      isStarted = true;
    });
    apis.getPatientFolders().then((value) {
      setState(() {
        isStarted = false;
        print(value);
        folderList = (value as List).map((e) => Folder.fromJson(e)).toList();
      });
    },
        onError: (err) => setState(() {
              print(err);
              isStarted = false;
            }));
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
                                  Navigator.of(context).pushNamed(
                                      '/document-details',
                                      arguments: 'Medikamentenpläne');
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
              XFile? pickedFile =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  selectedFile = pickedFile;
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
            onPressed: () => {},
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
                          child: Icon(Icons.close)),
                      Spacer(),
                      Icon(Icons.check)
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
                Flexible(
                    flex: 2,
                    child: Image.file(
                      File(selectedFile!.path),
                      width: MediaQuery.of(context).size.width * 1,
                      height: double.infinity,
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return const Center(
                            child: Text('This image type is not supported'));
                      },
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
