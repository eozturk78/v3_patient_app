class SecretQuestion {
  final int? secretQuestionId;
  final String question;

  SecretQuestion({required this.secretQuestionId, required this.question});

  factory SecretQuestion.fromJson(Map<String, dynamic> json) {
    return SecretQuestion(
        secretQuestionId: json['secretQuestionId'], question: json['question']);
  }
}
