import 'package:qrca_frontend/config/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PersonnelController {
  Api api = Api();

  Future getPersonnelById({required String id}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    http.Response response = await http.get(
      Uri.parse('${api.baseUrl}/personnel/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'auth-token': pref.getString('token').toString()
      },
    );

    Map jsonRes = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonRes};
    } else {
      return {"success": false, "data": jsonRes};
    }
  }
}
