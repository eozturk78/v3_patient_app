class Language {
  final int id;
  final String languageName;
  final String cultureName;
  final String url;

  Language(
      {required this.id,
      required this.languageName,
      required this.cultureName,
      required this.url});

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'],
      languageName: json['languageName'],
      cultureName: json['cultureName'],
      url: json['url'],
    );
  }
}
