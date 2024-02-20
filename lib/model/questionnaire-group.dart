import 'package:patient_app/shared/shared.dart';

class QuestionnaireGroup {
  final String name;
  final String nameShownToPatient;
  final String questionnaireId;
  QuestionnaireGroup(
      {required this.name,
      required this.nameShownToPatient,
      required this.questionnaireId});

  factory QuestionnaireGroup.fromJson(Map<String, dynamic> json) {
    Shared sh = Shared();
    return QuestionnaireGroup(
      name: json['name'],
      nameShownToPatient: json['nameShownToPatient'] != null
          ? json['nameShownToPatient']
          : json['name'],
      questionnaireId: sh.getBaseName(json['links']['questionnaire']),
    );
  }
}
