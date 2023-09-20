class NotificationHistory {
  final int notificationHistoryId;
  final int patientId;
  final String title;
  final String body;
  final DateTime? createdAt;
  bool isExpanded;

  NotificationHistory(
      {required this.notificationHistoryId,
      required this.patientId,
      required this.title,
      required this.body,
      required this.createdAt,
      required this.isExpanded});

  factory NotificationHistory.fromJson(Map<String, dynamic> json) {
    return NotificationHistory(
      notificationHistoryId: json['notificationHistoryId'],
      patientId: json['patientId'],
      title: json['title'],
      body: json['body'],
      createdAt: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : null,
      isExpanded: false,
    );
  }
}
