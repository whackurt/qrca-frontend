import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrca_frontend/features/attendance/attendance.screen.dart';
import 'package:qrca_frontend/features/auth/login.screen.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'ProximaNova',
    ),
    initialRoute: '/login',
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
  ));
}
