// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:qrca_frontend/core/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController _usernameController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  final _loginKey = GlobalKey<FormState>();

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
                  const Text(
                    'Invalid username and password.',
                    style: TextStyle(color: Color.fromARGB(255, 201, 44, 33)),
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
                      onPressed: () {
                        if (_loginKey.currentState!.validate()) {
                          String username = _usernameController.text;
                          String password = _passwordController.text;

                          print('Username: $username');
                          print('Password: $password');
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600),
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
