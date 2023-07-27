import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/shared.dart';

class CustomSubTotal extends StatelessWidget {
  final IconData? iconData;
  final String headText;
  final String? subText;
  final String? warningText;
  final int? colorState;
  const CustomSubTotal(this.iconData, this.headText, this.subText,
      this.warningText, this.colorState,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 2),
      decoration: menuBoxDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (iconData != null)
            Icon(
              iconData,
              size: 40,
              color: iconColor,
            ),
          SizedBox(
            height: 5,
          ),
          Text(
            headText,
            style: TextStyle(fontWeight: FontWeight.bold, color: menuTextColor),
          ),
          SizedBox(
            height: 5,
          ),
          if (subText != null)
            Text(
              subText!,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: menuTextColor),
            ),
          SizedBox(
            height: 5,
          ),
          if (warningText != null)
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Text(
                warningText!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorState == 10
                      ? const Color.fromARGB(255, 194, 13, 0)
                      : Color.fromARGB(255, 1, 68, 59),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
