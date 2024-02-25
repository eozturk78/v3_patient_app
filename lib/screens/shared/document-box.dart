import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';

class CustomDocumentBox extends StatelessWidget {
  final IconData? iconData;
  final String headText;
  int? fileCount;
  CustomDocumentBox(this.iconData, this.headText, this.fileCount, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.0,
      margin: EdgeInsets.only(bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headText,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          Spacer(),
          if (fileCount != null)
            Text(
              fileCount.toString(),
              style: TextStyle(
                  fontSize: 14, color: Color.fromARGB(255, 150, 159, 162)),
            ),
          Icon(
            Icons.arrow_forward_ios,
            color: Color.fromARGB(255, 150, 159, 162),
            size: 15,
          )
        ],
      ),
    );
  }
}
