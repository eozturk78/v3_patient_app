class File {
  final int id;
  final String fileName;
  final String fileUrl;

  File({required this.id, required this.fileName, required this.fileUrl});

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      id: json['id'],
      fileName: json['fileName'],
      fileUrl: json['fileUrl'],
    );
  }
}
