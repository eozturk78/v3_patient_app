import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/apis/apis.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/shared/shared.dart';
import 'package:photo_view/photo_view.dart';

class CustomMessageTextBubble extends StatefulWidget {
  CustomMessageTextBubble({
    required this.text,
    required this.dateTime,
    this.senderType,
    required this.senderTitle,
    this.image,
    required this.messageType,
  });

  final String? image;
  final String text;
  final String dateTime;
  final int? senderType; // 10 active user , 20 system
  final String senderTitle;
  final int? messageType; // 10 one message , 20 whole chage

  var startedLoadImage = false;
  @override
  State<CustomMessageTextBubble> createState() =>
      _CustomMessageTextBubbleState();
}

class _CustomMessageTextBubbleState extends State<CustomMessageTextBubble> {
  Apis apis = Apis();
  Shared sh = Shared();
  Uint8List? imageText;

  @override
  initState() {
    super.initState();
    if (widget.image != null) saveLoad();
  }

  saveLoad() {
    setState(() {
      widget.startedLoadImage = true;
    });
    apis.getAttachmentDataUrl(widget.image).then((value) {
      setState(() {
        imageText = value;
      });
      setState(() {
        widget.startedLoadImage = false;
      });
    },
        onError: (err) => setState(() {
              widget.startedLoadImage = false;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.senderType == 10
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          constraints: const BoxConstraints(
            maxHeight: double.infinity,
          ),
          width: widget.messageType != 10
              ? MediaQuery.of(context).size.width * 0.7
              : MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: widget.senderType == 10 ? mainItemColor : Colors.grey,
            border: Border.all(
              color: Color.fromARGB(255, 233, 232, 232),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.text,
                softWrap: true,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
              if (imageText != null && !widget.startedLoadImage)
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => onOpenImage(context, imageText!),
                    ).then((value) {});
                  },
                  child: Image.memory(
                    imageText!,
                  ),
                ),
              if (widget.startedLoadImage)
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color: mainButtonColor,
                )
            ],
          ),
        ),
        Text(
          '${widget.senderTitle} - ${widget.dateTime}',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(
          height: 2,
        )
      ],
    );
  }

  Widget onOpenImage(BuildContext context, Uint8List imageText) {
    Widget image = Image.memory(
      imageText,
      height: 200,
    );

    return AlertDialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(0),
      content: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Container(
            padding: EdgeInsets.zero,
            width: MediaQuery.of(context).size.width * 1,
            child: PhotoView.customChild(
              backgroundDecoration: BoxDecoration(color: Colors.transparent),
              child: image,
              minScale: PhotoViewComputedScale.contained * 1.2,
              initialScale: PhotoViewComputedScale.contained,
              basePosition: Alignment.center,
            ),
          );
        },
      ),
    );
  }
}
