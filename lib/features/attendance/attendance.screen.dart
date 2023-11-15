import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrca_frontend/core/app_colors.dart';
import 'package:qrca_frontend/widgets/toast.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String _scanBarcode = '';

  Future<void> scanQR() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      // ignore: avoid_print
      print(barcodeScanRes);

      // ignore: use_build_context_synchronously
      Toast().showSuccessToast(
          context: context, message: 'Attendance recorded successfully.');
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      Toast().showErrorToast(
          context: context, message: 'Failed to record attendance.');
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
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
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
              Text(_scanBarcode == '' ? '' : 'Rex Jimenez',
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800])),
              Text(_scanBarcode == '' ? '' : 'PS/Sgt.',
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
                  onPressed: () {},
                  child: const Text(
                    'Log out',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
