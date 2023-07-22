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
/*
[
    {
        "treatmentid": "1675600131928",
        "updatedat": "2023-02-05 12:32:18",
        "createdat": "2023-02-05 12:29:18",
        "sentdate": "2023-04-24 04:51:57",
        "rowcount": 1,
        "updated_by": "IT Erhan"
    },
    {
        "treatmentid": "1672760185047",
        "updatedat": "2023-01-03 18:51:50",
        "createdat": "2023-01-03 15:36:41",
        "sentdate": "2023-01-20 15:23:23",
        "rowcount": 1,
        "updated_by": "Helen Anderson"
    },
    {
        "treatmentid": "1672415358582",
        "updatedat": "2023-01-01 13:09:50",
        "createdat": "2023-01-01 12:14:46",
        "sentdate": "2023-01-01 13:15:02",
        "rowcount": 2,
        "updated_by": "Helen Anderson"
    }
]

 */