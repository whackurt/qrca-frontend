class Personnel {
  String qrCode;
  String firstName;
  String lastName;
  String position;

  Personnel({
    required this.qrCode,
    required this.firstName,
    required this.lastName,
    required this.position,
  });

  factory Personnel.fromJson(Map<String, dynamic> json) {
    return Personnel(
      qrCode: json['qr_code'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      position: json['position'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qr_code': qrCode,
      'first_name': firstName,
      'last_name': lastName,
      'position': position,
    };
  }
}
