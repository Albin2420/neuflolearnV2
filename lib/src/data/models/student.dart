class Student {
  int? studentId;
  String? mailId;
  String? name;
  String? phoneNumber;
  String? paymentId;
  int? organization;

  Student(
      {this.studentId,
      this.mailId,
      this.name,
      this.phoneNumber,
      this.paymentId,
      this.organization});

  factory Student.fromJson(Map<String, dynamic> json) => Student(
      studentId: json["student_id"],
      mailId: json["mail_id"],
      name: json["name"],
      phoneNumber: json["phone_number"],
      paymentId: json["payment_id"],
      organization: json['organization']);

  Map<String, dynamic> toJson() => {
        "student_id": studentId,
        "mail_id": mailId,
        "name": name,
        "phone_number": phoneNumber,
        "payment_id": paymentId,
        "organization": organization
      };
}
