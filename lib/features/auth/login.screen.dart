// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qrca_frontend/core/app_colors.dart';
import 'package:qrca_frontend/features/auth/auth.controller.dart';
import 'package:qrca_frontend/features/auth/clerk.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController _usernameController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  final _loginKey = GlobalKey<FormState>();
  final AuthController auth = AuthController();

  Map<String, dynamic> data = {};
  bool loading = false;
  String statusMsg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 60.0,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        width: 200.0,
                        image: AssetImage('assets/images/PNP-Logo.png'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Welcome to',
                    style: TextStyle(fontSize: 20.0, color: Colors.grey[700]),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .80,
                    child: Text(
                      'QR Code Attendance\nSystem for PNP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 28.0,
                          color: AppColors().mainRed),
                    ),
                  ),
                  const SizedBox(
                    height: 60.0,
                  ),
                  Text(
                    'LOG IN',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    height: 60.0,
                  ),
                  Form(
                      key: _loginKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                                labelText: 'Username',
                                border: OutlineInputBorder(),
                                fillColor: Colors.white),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    statusMsg,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 201, 44, 33)),
                  ),
                  const SizedBox(
                    height: 60.0,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors().mainRed,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: TextButton(
                      onPressed: () async {
                        setState(() {
                          statusMsg = '';
                        });
                        if (_loginKey.currentState!.validate()) {
                          String username = _usernameController.text;
                          String password = _passwordController.text;

                          if (_loginKey.currentState!.validate()) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            setState(() {
                              loading = true;
                            });
                            await auth
                                .login(Clerk(
                                    username: username, password: password))
                                .then((res) {
                              if (res['success']) {
                                setState(() {
                                  data = res['data'];
                                  loading = false;
                                });

                                prefs.setString('userId', data['id']);
                                prefs.setString('token', data['token']);

                                _usernameController.clear();
                                _passwordController.clear();

                                Navigator.popAndPushNamed(
                                    context, '/attendance');
                              } else {
                                setState(() {
                                  statusMsg = res['data']['message'];
                                  loading = false;
                                });
                              }
                            });
                          }
                        }
                      },
                      child: loading
                          ? const SpinKitDualRing(
                              color: Colors.white,
                              size: 25.0,
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight
                                      .w700), // Adjust text style as needed
                            ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
