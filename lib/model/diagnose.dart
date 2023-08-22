class PatientDiagnose {
  final int diagnoseId;
  final String diagnoseName;
  final String? subDiagnoseName;
  final String? doctor;
  final int securedDiagnoseG;
  final int suspicionV;
  final int exclusionA;
  final int stateAfter;
  final int diaLeft;
  final int diaRight;
  final int bothSide;
  final String? createdAt;
  bool? isExpanded;
  PatientDiagnose({
    required this.diagnoseId,
    required this.diagnoseName,
    required this.subDiagnoseName,
    required this.doctor,
    required this.securedDiagnoseG,
    required this.suspicionV,
    required this.exclusionA,
    required this.stateAfter,
    required this.diaLeft,
    required this.diaRight,
    required this.bothSide,
    required this.createdAt,
    this.isExpanded,
  });

  factory PatientDiagnose.fromJson(Map<String, dynamic> json) {
    return PatientDiagnose(
      diagnoseId: json['diagnoseId'],
      diagnoseName: json['diagnoseName'],
      subDiagnoseName: json['subDiagnoseName'],
      doctor: json['doctor'],
      securedDiagnoseG: json['securedDiagnoseG'],
      suspicionV: json['suspicionV'],
      exclusionA: json['exclusionA'],
      stateAfter: json['stateAfter'],
      diaLeft: json['diaLeft'],
      diaRight: json['diaRight'],
      bothSide: json['bothSide'],
      createdAt: json['createdDate'],
      isExpanded: false,
    );
  }
}
