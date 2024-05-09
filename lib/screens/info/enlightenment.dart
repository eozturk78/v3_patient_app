import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:patient_app/shared/shared.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../shared/bottom-menu.dart';
import '../shared/library-box.dart';
import '../shared/medication-plan-box.dart';
import 'package:photo_view/photo_view_gallery.dart';

class EnlightenmentPage extends StatefulWidget {
  const EnlightenmentPage({super.key});

  @override
  State<EnlightenmentPage> createState() => _EnlightenmentPageState();
}

class _EnlightenmentPageState extends State<EnlightenmentPage> {
  Shared sh = Shared();
  @override
  void initState() {
    super.initState();
    sh.openPopUp(context, 'enlightenment');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage(sh.getLanguageResource('clarification'), context),
      body: SafeArea(
        // Wrap your body with SafeArea
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                verticalDirection: VerticalDirection.down,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => onOpenImage(
                            context, "assets/images/enlightenment-1.jpg"),
                      ).then((value) {});
                    },
                    child: Image.asset(
                      "assets/images/enlightenment-1.jpg",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => onOpenImage(
                            context, "assets/images/enlightenment-2.jpg"),
                      ).then((value) {});
                    },
                    child: Image.asset(
                      "assets/images/enlightenment-2.jpg",
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      ////bottomNavigationBar: BottomNavigatorBar(selectedIndex: 3),
    );
  }

  Widget onOpenImage(BuildContext context, String imageText) {
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
                AspectRatio(
                  aspectRatio: 0.7,
                  child: PhotoViewGallery.builder(
                    backgroundDecoration: BoxDecoration(color: Colors.white),
                    scrollPhysics: BouncingScrollPhysics(),
                    builder: (BuildContext context, int index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: AssetImage(imageText),
                      );
                    },
                    itemCount: 1,
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
