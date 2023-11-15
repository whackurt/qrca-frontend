import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrca_frontend/features/attendance/attendance.screen.dart';
import 'package:qrca_frontend/features/auth/login.screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool tokenPresent = await isTokenPresent();

  runApp(QRCA(tokenPresent: tokenPresent));
}

class QRCA extends StatelessWidget {
  final bool tokenPresent;

  const QRCA({super.key, required this.tokenPresent});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'ProximaNova',
      ),
      initialRoute: tokenPresent ? '/attendance' : '/login',
      home: const AttendanceScreen(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/login':
            return CupertinoPageRoute(
                builder: (_) => const LoginScreen(), settings: settings);
          case '/attendance':
            return CupertinoPageRoute(
                builder: (_) => const AttendanceScreen(), settings: settings);

          default:
            return CupertinoPageRoute(
                builder: (_) => const LoginScreen(), settings: settings);
        }
      },
    );
  }
}

Future<bool> isTokenPresent() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token'); // Replace 'token' with your key

  return token != null && token.isNotEmpty;
}
