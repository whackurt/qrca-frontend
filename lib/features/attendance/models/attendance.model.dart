class Attendance {
  String qrCode;
  String dateTime;
  Attendance({required this.qrCode, required this.dateTime});

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      qrCode: json['qr_code'],
      dateTime: json['dateTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'qr_code': qrCode, 'dateTime': dateTime};
  }
}
