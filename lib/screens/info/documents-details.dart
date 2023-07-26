import 'dart:async';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../apis/apis.dart';
import '../../model/file.dart';
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
  late String screenTitle;
  Apis apis = Apis();
  List<File> fileList = [];
  bool isStarted = true;
  PDFDocument? document;
  String? imageUrl;
  bool isPdf = false;

  @override
  void initState() {
    super.initState();
    getFiles();
  }

  getFiles() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      screenTitle = pref.getString("folderName")!;
      var folderId = int.parse(pref.getString("folderId")!);
      isStarted = true;
      Apis apis = Apis();
      apis.getPatientFiles(folderId).then(
            (value) => {
              setState(() {
                isStarted = false;
                print(value);
                fileList =
                    (value as List).map((e) => File.fromJson(e)).toList();
              })
            },
            onError: (err) => setState(
              () {
                isStarted = false;
              },
            ),
          );
    });
  }

  openDialog() {
    showDialog(
      context: context,
      builder: (context) => onOpenImage(
        context,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalObjectKey<ExpandableFabState>(context);
    String title = "MP";

    return Scaffold(
      appBar: leadingSubpage(screenTitle, context),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: isStarted
              ? CircularProgressIndicator(
                  color: mainButtonColor,
                )
              : fileList.isEmpty
                  ? Center(child: Text("no data found"))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          for (var item in fileList)
                            GestureDetector(
                                onTap: () {
                                  var fileUrl =
                                      '${apis.apiPublic}/patient_files/${item.fileUrl}';
                                  if (fileUrl.contains('pdf')) {
                                    PDFDocument.fromURL(fileUrl).then((value) {
                                      setState(() {
                                        isPdf = true;
                                        document = value;
                                        openDialog();
                                      });
                                    });
                                  } else {
                                    setState(() {
                                      isPdf = false;
                                      imageUrl = fileUrl;
                                      openDialog();
                                    });
                                  }
                                },
                                child: CustomDocumentBox(
                                    Icons.file_copy_rounded,
                                    item.fileName,
                                    null)),
                        ],
                      ),
                    ),
        ),
      ),
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
            child: Column(children: [
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
                Flexible(child: Image.network(imageUrl!))
            ]),
          );
        },
      ),
    );
  }
}
