class Folder {
  final int id;
  final int fileCount;
  final String folderName;

  Folder({required this.id, required this.fileCount, required this.folderName});

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      id: json['id'],
      fileCount: json['fileCount'],
      folderName: json['folderName'],
    );
  }
}
