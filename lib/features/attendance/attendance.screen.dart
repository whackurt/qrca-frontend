import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrca_frontend/core/app_colors.dart';
import 'package:qrca_frontend/features/attendance/attendance.controller.dart';
import 'package:qrca_frontend/features/attendance/models/attendance.model.dart';
import 'package:qrca_frontend/features/attendance/personnel.controller.dart';
import 'package:qrca_frontend/features/auth/login.screen.dart';
import 'package:qrca_frontend/widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceController attendanceController = AttendanceController();
  final PersonnelController personnelController = PersonnelController();

  String _scanBarcode = '';
  bool loading = false;

  Map data = {};
  Map personnelData = {};

  Future<void> scanQR() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);

      // ignore: avoid_print
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      Toast().showErrorToast(
          context: context, message: 'Failed to record attendance.');
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });

    await attendanceController
        .createAttendance(Attendance(qrCode: _scanBarcode))
        .then((res) {
      if (res['success']) {
        setState(() {
          data = res['data'];
        });
        Toast().showSuccessToast(
            context: context, message: 'Attendance recorded successfully.');
      } else {
        Toast().showErrorToast(
            context: context, message: 'Failed to record attendance.');
      }
    });

    await personnelController
        .getPersonnelById(id: data['personnel'])
        .then((res) {
      if (res['success']) {
        setState(() {
          personnelData = res['data'];
        });
      } else {
        Toast().showErrorToast(
            context: context, message: 'Failed to fetch personnel data.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors().mainRed,
        title: const Text('Scan QR Code'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 25.0,
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
              Text('Scan QR Code to record attendance',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(fontSize: 18, color: Colors.grey[800])),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                  _scanBarcode == ''
                      ? ''
                      : '${personnelData['first_name']} ${personnelData['last_name']}',
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800])),
              Text(_scanBarcode == '' ? '' : '${personnelData['position']}',
                  maxLines: 2,
                  style: TextStyle(fontSize: 20, color: Colors.grey[800])),
              const SizedBox(
                height: 30.0,
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                height: 270.0,
                width: MediaQuery.of(context).size.width * .60,
                decoration: BoxDecoration(color: Colors.grey[200]),
                child: Column(
                  children: [
                    Text(_scanBarcode == '' ? '' : _scanBarcode,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: AppColors().mainRed)),
                    _scanBarcode == ''
                        ? const Text('')
                        : QrImageView(
                            data: _scanBarcode,
                            version: QrVersions.auto,
                            size: 200,
                            errorStateBuilder: (ctx, err) {
                              return const Center(
                                child: Text(
                                  'Something went wrong!!!',
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
              const SizedBox(
                height: 80.0,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors().mainRed,
                    borderRadius: BorderRadius.circular(5.0)),
                child: TextButton(
                  onPressed: () => scanQR(),
                  child: const Text(
                    'Scan QR Code',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors().mainRed,
                    borderRadius: BorderRadius.circular(5.0)),
                child: TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Confirm Log out',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            content: loading
                                ? const SpinKitDualRing(
                                    color: Colors.blue,
                                    size: 30.0,
                                  )
                                : const Text(
                                    'Are you sure you want to log out?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the alert dialog
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  setState(() {
                                    loading = true;
                                  });
                                  pref.clear();

                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context, rootNavigator: true)
                                      .pushAndRemoveUntil(
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen()),
                                          (route) => false);
                                },
                                child: const Text(
                                  'Log out',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  child: const Text(
                    'Log out',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
