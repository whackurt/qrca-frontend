import 'package:qrca_frontend/config/api.dart';
import 'package:qrca_frontend/features/attendance/models/attendance.model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AttendanceController {
  Api api = Api();

  Future createAttendance(Attendance attendance) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    http.Response response = await http.post(
      Uri.parse('${api.baseUrl}/attendance'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'auth-token': pref.getString('token').toString()
      },
      body: jsonEncode(<String, String>{"qr_code": attendance.qrCode}),
    );

    Map jsonRes = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 201) {
      print(jsonRes);
      return {"success": true, "data": jsonRes};
    } else {
      return {"success": false, "data": jsonRes};
    }
  }
}
