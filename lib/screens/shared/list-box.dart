import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';

class CustomListComponent extends StatelessWidget {
  final IconData? iconData;
  final String headText;
  final String? subText;
  final String? warningText;
  final int? colorState;
  const CustomListComponent(this.iconData, this.headText, this.subText,
      this.warningText, this.colorState,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 2),
      decoration: BoxDecoration(
        color: mainItemColor,
        border: Border.all(
          color: Color.fromARGB(255, 233, 232, 232),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          if (iconData != null)
            Icon(
              iconData,
              size: 40,
              color: iconColor,
            ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headText,
                style: TextStyle(
                    color: menuTextColor, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                subText!,
                style: TextStyle(
                    color: menuTextColor, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
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
        ],
      ),
    );
  }
}
