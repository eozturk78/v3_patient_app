import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v3_patient_app/colors/colors.dart';

class CustomLibraryBox extends StatelessWidget {
  final String text;
  const CustomLibraryBox(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 15),
            constraints: const BoxConstraints(
              maxHeight: double.infinity,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromARGB(255, 233, 232, 232),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.picture_as_pdf,
                  color: iconColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    text,
                    softWrap: true,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )),
        SizedBox(
          height: 2,
        )
      ],
    );
  }
}
