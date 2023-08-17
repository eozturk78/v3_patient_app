class Library {
  final String title;
  final String url;

  Library({required this.title, required this.url});

  factory Library.fromJson(Map<String, dynamic> json) {
    return Library(title: json['title'], url: json['url']);
  }
}
