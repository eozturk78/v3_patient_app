class MessageNotification {
  final int notificationId;
  final String notificationTitle;
  final String notificationContent;
  final int notificationtype;
  final String createdAt;
  String? createdBy;
  String? attachment;
  String? thread;

  MessageNotification(
      {required this.notificationId,
      required this.notificationTitle,
      required this.notificationContent,
      required this.notificationtype,
      required this.createdAt,
      required this.createdBy,
      this.attachment,
      this.thread});

  factory MessageNotification.fromJson(Map<String, dynamic> json) {
    return MessageNotification(
      notificationId: json['notificationid'],
      notificationTitle: json['notificationtitle'],
      notificationtype: json['notificationtype'],
      notificationContent: json['notificationcontent'],
      createdAt: json['createdat'],
      createdBy: json['createdby'],
      attachment: json['attachment'],
      thread: json['thread'],
    );
  }
}
