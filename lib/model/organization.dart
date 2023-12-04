class Organization {
  final String name;
  final String organization;

  Organization({required this.name, required this.organization});

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      name: json['name'],
      organization: json['organization'],
    );
  }
}
