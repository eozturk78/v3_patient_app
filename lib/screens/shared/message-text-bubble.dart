import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';

class CustomMessageTextBubble extends StatelessWidget {
  final String? image;
  final String text;
  final String dateTime;
  final int? senderType; // 10 active user , 20 system
  final String senderTitle;
  const CustomMessageTextBubble(
      this.image, this.text, this.dateTime, this.senderType, this.senderTitle,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          senderType == 10 ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          constraints: const BoxConstraints(
            maxHeight: double.infinity,
          ),
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: senderType == 10 ? mainItemColor : Colors.grey,
            border: Border.all(
              color: Color.fromARGB(255, 233, 232, 232),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              Text(
                text,
                softWrap: true,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
              if (image != null)
                Image.asset(
                  image!,
                ),
            ],
          ),
        ),
        Text(
          '${senderTitle} - ${dateTime}',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(
          height: 2,
        )
      ],
    );
  }
}
