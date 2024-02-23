import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/apis/apis.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/shared/shared.dart';
import 'package:patient_app/shared/toast.dart';
import 'package:photo_view/photo_view.dart';

class CustomMessageTextBubble extends StatefulWidget {
  CustomMessageTextBubble({
    required this.text,
    required this.dateTime,
    this.senderType,
    required this.senderTitle,
    this.readAt,
    this.image,
    required this.messageType,
    this.messageId,
  });

  final String? image;
  final String text;
  final String dateTime;
  final String? messageId;
  final int? senderType; // 10 active user , 20 system
  final String senderTitle;
  final String? readAt;
  final int? messageType; // 10 one message , 20 whole chage
  bool showReadDateTime = false;
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
    //if (widget.senderType == 10 && widget.readAt == null) markAsRead();
  }

  markAsRead() {
    apis
        .markAsRead(widget.messageId)
        .then((value) {}, onError: (err) => {sh.redirectPatient(err, context)});
  }

  saveLoad() {
    setState(() {
      widget.startedLoadImage = true;
    });
    apis.getAttachmentDataUrl(widget.image).then(
      (value) {
        setState(
          () {
            imageText = value;
            print(value);
            widget.startedLoadImage = false;
          },
        );
      },
      onError: (err) => setState(
        () {
          sh.redirectPatient(err, context);
          imageText = null;
          widget.startedLoadImage = false;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.senderType == 20
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
            color: widget.senderType == 20 ? fromMessage : toMessage,
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
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              if (imageText != null && !widget.startedLoadImage)
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => onOpenImage(context, imageText!),
                    ).then((value) {});
                  },
                  child: SizedBox(
                    height: 200,
                    child: Image.memory(
                      imageText!,
                      errorBuilder: (context, error, stackTrace) => SizedBox(
                        width: 0,
                        height: 0,
                      ),
                    ),
                  ),
                ),
              if (widget.startedLoadImage)
                SizedBox(
                  height: 200,
                  child: Center(
                    child: Transform.scale(
                      scale: 0.5,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: mainButtonColor,
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${widget.senderTitle} - ${widget.dateTime}',
                    style: TextStyle(
                        color: Color.fromARGB(255, 245, 245, 245),
                        fontSize: 11),
                  ),
                  Spacer(),
                  if (widget.readAt != null && widget.senderType == 20)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          widget.showReadDateTime = true;
                        });
                        Future.delayed(const Duration(seconds: 3), () {
                          setState(() {
                            setState(() {
                              widget.showReadDateTime = false;
                            });
                          });
                        });
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(2)),
                        alignment: Alignment.bottomRight,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Icon(
                        Icons.check,
                        color: const Color.fromARGB(255, 5, 110, 9),
                        size: 15,
                      ),
                    )
                ],
              ),
              if (widget.showReadDateTime == true && widget.readAt != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(sh.formatDateTime(widget.readAt!),
                        style: TextStyle(
                            fontSize: 11,
                            color: const Color.fromARGB(255, 5, 110, 9)))
                  ],
                ),
            ],
          ),
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
              minScale: PhotoViewComputedScale.contained * 1,
              initialScale: PhotoViewComputedScale.contained,
              basePosition: Alignment.center,
            ),
          );
        },
      ),
    );
  }
}
