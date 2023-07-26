import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';

class QuestionBox extends StatelessWidget {
  final String headText;
  int? fileCount;
  QuestionBox(this.headText, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.0,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.only(right: 3),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromARGB(255, 233, 232, 232),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
          Spacer(),
          if (fileCount != null)
            Text(
              fileCount.toString(),
              style: TextStyle(fontSize: 18),
            )
        ],
      ),
    );
  }
}
