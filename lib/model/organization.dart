class Organization {
  final int organizationId;
  final String organizationTitle;
  final String address;
  final String email;
  final String phoneNumber;
  final String organization;
  final String name;

  Organization({
    required this.organizationId,
    required this.organizationTitle,
    required this.address,
    required this.email,
    required this.phoneNumber,
    required this.organization,
    required this.name,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
        organizationId: json['organizationId'],
        organizationTitle: json['organizationTitle'],
        address: json['address'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        name: '',
        organization: "");
  }
}
