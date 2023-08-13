class PatientContact {
  final int id;
  final String firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? email;
  final String? institutionName;
  final String? institutionAddress;
  int category=1;


  PatientContact({required this.id, required this.firstName, this.lastName, this.phoneNumber, this.email, this.institutionName, this.institutionAddress, required this.category});

  factory PatientContact.fromJson(Map<String, dynamic> json) {
    return PatientContact(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      institutionName: json['institution_name'],
      institutionAddress: json['institution_address'],
      category: json['category'],
    );
  }
}
