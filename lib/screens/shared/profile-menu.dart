import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/shared.dart';

class CustomProfileMenu extends StatelessWidget {
  final IconData? iconData;
  final String headText;
  const CustomProfileMenu(this.iconData, this.headText, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.0,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.only(right: 3),
      decoration: menuBoxDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (this.iconData != null)
            Icon(
              iconData,
              size: 40,
              color: iconColor,
            ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headText,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
