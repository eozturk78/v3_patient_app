class Meeting {
  final int id;
  final String meetingTitle;
  final DateTime meetingDate;
  final String meetingLink;

  Meeting({required this.id, required this.meetingTitle, required this.meetingDate, required this.meetingLink});

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['id'],
      meetingTitle: json['meeting_title'],
      meetingDate: json['meeting_date'],
      meetingLink: json['meeting_link'],
    );
  }
}
