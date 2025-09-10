class PostalCode {
  final String? postalCode;

  PostalCode({required this.postalCode});

  factory PostalCode.fromJson(Map<String, dynamic> json) {
    return PostalCode(postalCode: json['postalCode']);
  }
}
