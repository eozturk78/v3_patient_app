import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_framework/responsive_value.dart';

import '../../model/scale-size.dart';

class CustomSubTotal extends StatelessWidget {
  dynamic iconData;
  String headText;
  String? subText;
  final String? warningText;
  final int? colorState;

  CustomSubTotal(this.iconData, this.headText, this.subText, this.warningText,
      this.colorState,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.38,
      margin: EdgeInsets.only(bottom: 10, left: 10),
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 2),
      decoration: menuBoxDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (iconData != null) ...[
            if (iconData is IconData) // Check if it's IconData
              Icon(
                iconData,
                size: 50,
                color: iconColor,
              )
            else if (iconData is Widget) // Check if it's Widget (for SVG)
              Container(
                child: iconData,
                width: 50,
                height: 50,
              ),
          ],
          SizedBox(
            height: 15,
          ),
          Text(
            headText,
            overflow: TextOverflow.visible,
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
          SizedBox(
            height: 5,
          ),
          if (subText != null)
            Text(
              subText!,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: menuTextColor),
              textScaleFactor: ScaleSize.textScaleFactor(context),
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
                textScaleFactor: ScaleSize.textScaleFactor(context),
              ),
            ),
        ],
      ),
    );
  }
}
