class Attendance {
  String qrCode;

  Attendance({
    required this.qrCode,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      qrCode: json['qr_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qr_code': qrCode,
    };
  }
}
