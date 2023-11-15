import 'dart:convert';
import 'package:qrca_frontend/config/api.dart';
import 'package:qrca_frontend/features/auth/clerk.model.dart';
import 'package:http/http.dart' as http;

class AuthController {
  Api api = Api();

  Future login(Clerk clerk) async {
    http.Response response = await http.post(
      Uri.parse('${api.baseUrl}/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(clerk),
    );

    Map jsonRes = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return {"success": true, "data": jsonRes};
    } else {
      return {"success": false, "data": jsonRes};
    }
  }
}
