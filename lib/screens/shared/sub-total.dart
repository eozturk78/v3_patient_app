import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v3_patient_app/colors/colors.dart';
import 'package:v3_patient_app/screens/shared/bottom-menu.dart';
import 'package:v3_patient_app/screens/shared/shared.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_framework/responsive_value.dart';

import '../../model/scale-size.dart';

import 'package:badges/badges.dart' as badges;

class CustomSubTotal extends StatelessWidget {
  dynamic iconData;
  String? headText;
  String? subText;
  final bool showNotification;
  final String? warningText;
  final int? colorState;

  CustomSubTotal(this.iconData, this.headText, this.subText, this.warningText,
      this.colorState, this.showNotification,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.39,
      margin: EdgeInsets.only(bottom: 10, left: 10),
      height: 110.0,
      decoration: menuBoxDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (iconData != null) ...[
            if (iconData is IconData) // Check if it's IconData
              Icon(
                iconData,
                size: 35,
                color: iconColor,
              )
            else if (iconData is Widget) // Check if it's Widget (for SVG)
              if (showNotification && unreadMessageCount != 0)
                badges.Badge(
                  badgeStyle: badges.BadgeStyle(badgeColor: Colors.red),
                  badgeContent: Text(
                    unreadMessageCount.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  child: Container(
                    child: iconData,
                    width: 35,
                    height: 35,
                  ),
                )
              else
                Container(
                  child: iconData,
                  width: 35,
                  height: 35,
                )
          ],
          SizedBox(
            height: 15,
          ),
          if (headText != null)
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Text(
                headText!,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: ResponsiveValue(
                    context,
                    defaultValue: 12.0,
                    conditionalValues: [
                      Condition.largerThan(
                        //Tablet
                        name: MOBILE,
                        value: 16.0,
                      ),
                    ],
                  ).value!,
                  color: menuTextColor,
                ),
                textAlign: TextAlign.center,
                textScaleFactor: ScaleSize.textScaleFactor(context),
              ),
            ),
          SizedBox(
            height: 5,
          ),
          if (subText != null)
            FittedBox(
              child: Text(
                subText!,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: menuTextColor),
                textScaleFactor: ScaleSize.textScaleFactor(context),
              ),
            ),
          SizedBox(
            height: 5,
          ),
          if (warningText != null)
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Text(
                warningText!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorState == 10
                      ? const Color.fromARGB(255, 194, 13, 0)
                      : Color.fromARGB(255, 1, 68, 59),
                ),
                textScaleFactor: ScaleSize.textScaleFactor(context),
              ),
            ),
        ],
      ),
    );
  }
}
