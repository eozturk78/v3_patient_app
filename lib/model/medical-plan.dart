class MedicalPlan {
  final String treatmentId;
  String mpName;
  DateTime? updatedAt;
  final String createdAt;
  DateTime? sendDate;
  final int rowCount;
  String? updatedBy;
  bool isExpanded;
  List<MedicalPlanRows> rows;
  MedicalPlan({
    required this.treatmentId,
    required this.mpName,
    this.updatedAt,
    required this.createdAt,
    required this.sendDate,
    required this.rowCount,
    required this.updatedBy,
    required this.isExpanded,
    required this.rows,
  });

  factory MedicalPlan.fromJson(Map<String, dynamic> json) {
    return MedicalPlan(
      treatmentId: json['treatmentid'],
      mpName: json['mpname'] ?? "",
      updatedAt:
          json['updatedat'] != null ? DateTime.parse(json['updatedat']) : null,
      createdAt: json['createdat'],
      sendDate:
          json['sendDate'] != null ? DateTime.parse(json['sendDate']) : null,
      rowCount: json['rowcount'],
      updatedBy: json['updated_by'],
      isExpanded: false,
      rows: (json['rows'] as List)
          .map((e) => MedicalPlanRows.fromJson(e))
          .toList(),
    );
  }
}

class MedicalPlanRows {
  final String activeingredient;
  String commercialname;
  String dosestrength;
  String form;
  String applicationform;
  String doseearly;
  String dosenoon;
  String doseafternoon;
  String doseevening;
  MedicalPlanRows({
    required this.activeingredient,
    required this.commercialname,
    required this.dosestrength,
    required this.form,
    required this.applicationform,
    required this.doseearly,
    required this.dosenoon,
    required this.doseafternoon,
    required this.doseevening,
  });

  factory MedicalPlanRows.fromJson(Map<String, dynamic> json) {
    return MedicalPlanRows(
      commercialname: json['commercialname'],
      activeingredient: json['activeingredient'],
      dosestrength: json['dosestrength'],
      form: json['form'],
      applicationform: json['applicationform'],
      doseearly: json['doseearly'],
      dosenoon: json['dosenoon'],
      doseafternoon: json['doseafternoon'],
      doseevening: json['doseevening'],
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