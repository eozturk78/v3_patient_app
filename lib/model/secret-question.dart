class SecretQuestion {
  final int? id;
  final String question;

  SecretQuestion({required this.id, required this.question});

  factory SecretQuestion.fromJson(Map<String, dynamic> json) {
    return SecretQuestion(id: json['id'], question: json['question']);
  }
}
