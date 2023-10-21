import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';

import '../../model/scale-size.dart';

class CustomMessageListContainer extends StatelessWidget {
  final IconData? iconData;
  final String headText;
  final String dateTime;
  const CustomMessageListContainer(this.iconData, this.headText, this.dateTime,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.0,
      width: MediaQuery.of(context).size.width * 0.90,
      padding: EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromARGB(255, 233, 232, 232),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                iconData,
                size: 40,
                color: iconColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                headText,
                overflow: TextOverflow.ellipsis,
                textScaleFactor: ScaleSize.textScaleFactor(context),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            dateTime,
            style: TextStyle(fontWeight: FontWeight.normal),
            textScaleFactor: ScaleSize.textScaleFactor(context),
          ),
        ],
      ),
    );
  }
}
