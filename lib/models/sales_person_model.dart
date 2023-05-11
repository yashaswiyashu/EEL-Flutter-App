class SalesPersonModel {
  final String uid;
  final String name;
  final String education;
  final String role;
  final String adhaarNumber;
  final String phoneNumber;
  final String email;
  final String password;
  final String address1;
  final String address2;
  final String district;
  final String state;
  final String pincode;

  SalesPersonModel(
  {required this.uid,
  required this.name,
  required this.education,
  required this.role,
  required this.adhaarNumber,
  required this.phoneNumber,
  required this.email,
  required this.password,
  required this.address1,
  required this.address2,
  required this.district,
  required this.state,
  required this.pincode});
}
