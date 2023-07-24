class PatientGroup {
  final String name;
  Link links;

  PatientGroup({
    required this.name,
    required this.links,
  });

  factory PatientGroup.fromJson(Map<String, dynamic> json) {
    return PatientGroup(
      name: json['name'],
      links: Link.fromJson(json['links']),
    );
  }
}

class Link {
  String organization;
  String patientGroup;
  Link({required this.organization, required this.patientGroup});
  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      organization: json['organization'],
      patientGroup: json['patientGroup'],
    );
  }
}
