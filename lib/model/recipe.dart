class Recipe {
  final int? recipeId;
  final int? patientId;
  final String? recipeName;
  final DateTime? createdAt;
  final String? recipeDescription;
  final String? qrCodeImage;
  bool isExpanded;

  Recipe(
      {required this.recipeId,
      required this.patientId,
      required this.recipeName,
      required this.recipeDescription,
      required this.qrCodeImage,
      required this.createdAt,
      required this.isExpanded});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      recipeId: json['recipeId'],
      patientId: json['patientId'],
      recipeName: json['recipeName'],
      recipeDescription: json['recipeDescription'],
      qrCodeImage: json['qrCodeImage'],
      createdAt: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : null,
      isExpanded: false,
    );
  }
}
