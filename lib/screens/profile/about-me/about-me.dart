import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patient_app/apis/apis.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/shared.dart';
import '../../shared/bottom-menu.dart';
import '../../shared/info-box-decoration.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({super.key});
  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  Apis apis = Apis();
  Shared sh = Shared();
  bool isStarted = true;
  XFile? selectedPhotoImage;
  XFile? selectedFile;
  var aboutPatient;
  String? imageUrl;
  @override
  void initState() {
    super.initState();
    getAboutMe();
  }

  getAboutMe() async {
    selectedFile = null;
    selectedPhotoImage = null;
    setState(() {
      isStarted = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    await apis.patientInfo().then((value) {
      print(value);
      setState(() {
        aboutPatient = value;
        if (aboutPatient["profilephoto"] != null &&
            aboutPatient["profilephoto"] != 'null' &&
            aboutPatient["profilephoto"] != '')
          imageUrl =
              '${apis.apiPublic}/patient_files/${aboutPatient["profilephoto"]}';
        isStarted = false;
      });
    }, onError: (err) {
      sh.redirectPatient(err, context);
      setState(() {
        isStarted = false;
      });
    });
  }

  openDialog() {
    showDialog(
      context: context,
      builder: (context) => onOpenImage(context, imageUrl),
    ).then((value) {
      getAboutMe();
    });
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalObjectKey<ExpandableFabState>(context);
    return Scaffold(
      appBar: leadingSubpage('Über mich', context),
      body: SafeArea(
        // Wrap your body with SafeArea
        child: Padding(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Center(
              child: isStarted
                  ? Center(
                      child: CircularProgressIndicator(
                      color: mainButtonColor,
                    ))
                  : aboutPatient == null
                      ? Center(child: Text("Keine Daten gefunden"))
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                if (imageUrl != null) openDialog();
                              },
                              child: imageUrl == null
                                  ? CircleAvatar(
                                      backgroundColor: mainButtonColor,
                                      child: Text(
                                        '${aboutPatient["firstName"].toString().substring(0, 1)} ${aboutPatient["lastName"].toString().substring(0, 1)}',
                                        style: TextStyle(fontSize: 25),
                                      ),
                                      minRadius: 40,
                                      maxRadius: 50,
                                    )
                                  : CircleAvatar(
                                      backgroundImage: NetworkImage(imageUrl!),
                                      minRadius: 40,
                                      maxRadius: 50,
                                    ),
                            ),
                            Center(
                              child: Text(
                                '${aboutPatient["firstName"]} ${aboutPatient["lastName"]}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Über mich",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: infoBoxDecoration,
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: iconColor,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(getLocalizedGender(
                                              aboutPatient['sex'], context) ??
                                          aboutPatient['sex']),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.cake,
                                        color: iconColor,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(aboutPatient['dateOfBirth'] != null
                                          ? formatDate(
                                              aboutPatient['dateOfBirth'])
                                          : "")
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(aboutPatient['comment'] ?? ""),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Kontaktinformationen",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: infoBoxDecoration,
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.email,
                                        color: iconColor,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(aboutPatient['email'] ?? "")
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone_iphone,
                                        color: iconColor,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(aboutPatient['mobilePhone'] ?? "")
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        color: iconColor,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(aboutPatient['phone'] ?? "")
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.home,
                                        color: iconColor,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text("${aboutPatient['address']}"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 38,
                                      ),
                                      Text(
                                          "${aboutPatient['postalCode']} / ${aboutPatient['city']}")
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Patientengruppen",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: infoBoxDecoration,
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  for (var item
                                      in aboutPatient['patientGroups'])
                                    Column(children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.info,
                                            color: iconColor,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(item['name'])
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ])
                                ],
                              ),
                            )
                          ],
                        ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 0),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: key,
        distance: 60.0,
        type: ExpandableFabType.up,
        child: const Icon(
          Icons.image,
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
            onPressed: () async {
              if (await sh.checkPermission(
                      context, Permission.camera, sh.cameraPermissionText) ==
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
                      getAboutMe();
                    });
                  });
                }
              }
            },
            icon: new Icon(Icons.camera_alt),
            label: Text("Foto aufnehmen"),
          ),
          FloatingActionButton.extended(
            onPressed: () async {
              if ((Platform.isIOS &&
                          await sh.checkPermission(context, Permission.photos,
                              sh.galeryPermissionText) ||
                      (Platform.isAndroid &&
                          await sh.checkPermission(context, Permission.storage,
                              sh.galeryPermissionText))) ==
                  true) {
                XFile? pickedFile = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (pickedFile != null) {
                  setState(() {
                    selectedFile = pickedFile!;
                    showDialog(
                      context: context,
                      builder: (context) => onOpenImage2(
                        context,
                      ),
                    ).then((resp) {
                      if (resp != null) Navigator.pop(context, resp);
                      getAboutMe();
                    });
                  });
                }
              }
            },
            icon: new Icon(Icons.file_present_outlined),
            label: Text("Foto hinzufügen"),
          ),
        ],
      ),
    );
  }

  Widget onAreYouSureDeleteFile(
    BuildContext context,
  ) {
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
                        apis.deletePatientProfilePhoto().then((resp) {
                          imageUrl = null;

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
                    TextButton(onPressed: () {}, child: Text("")),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => onAreYouSureDeleteFile(context),
                        ).then((resp) {
                          if (resp != null) Navigator.of(context).pop();
                          imageUrl = null;
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

  Widget onOpenImage2(BuildContext context) {
    bool isSendEP = false;
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
                          File? file;
                          if (selectedPhotoImage == null &&
                              selectedFile != null) {
                            file = File(selectedFile!.path!);
                          }
                          if (selectedPhotoImage != null)
                            file = File(selectedPhotoImage!.path!);
                          setState(() {
                            isSendEP = true;
                          });
                          if (file != null) {
                            apis.setPatientProfilePhoto(file).then(
                              (value) {
                                print(value);
                                setState(() {
                                  isSendEP = false;
                                });
                                Navigator.of(context).pop();
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
                        },
                        child: !isSendEP
                            ? Icon(
                                Icons.check,
                                size: 30,
                              )
                            : SizedBox(
                                child:
                                    Center(child: CircularProgressIndicator()),
                                height: 15.0,
                                width: 15.0,
                              ),
                      )
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
                if (selectedPhotoImage != null || selectedFile != null)
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
              ],
            ),
          );
        },
      ),
    );
  }
}
