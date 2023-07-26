import 'package:patient_app/shared/shared.dart';

class QuestionnaireGroup {
  final String name;
  String? nameShownToPatient;
  final String questionnaireId;
  QuestionnaireGroup(
      {required this.name,
      this.nameShownToPatient,
      required this.questionnaireId});

  factory QuestionnaireGroup.fromJson(Map<String, dynamic> json) {
    Shared sh = Shared();
    return QuestionnaireGroup(
      name: json['name'],
      nameShownToPatient: json['nameShownToPatient'],
      questionnaireId: sh.getBaseName(json['links']['questionnaire']),
    );
  }
}
