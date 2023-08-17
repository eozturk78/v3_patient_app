class PatientFile {
  final int id;
  final String fileName;
  final String fileUrl;

  PatientFile({required this.id, required this.fileName, required this.fileUrl});

  factory PatientFile.fromJson(Map<String, dynamic> json) {
    return PatientFile(
      id: json['id'],
      fileName: json['fileName'],
      fileUrl: json['fileUrl'],
    );
  }
}
