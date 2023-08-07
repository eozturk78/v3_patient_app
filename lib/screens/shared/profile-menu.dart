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
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(right: 5,left: 15),
      decoration: menuBoxDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (iconData != null)
            Icon(
              iconData,
              size: 35,
              color: iconColor,
            ),
          const SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headText,
                style: const TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
