import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class Toast {
  void showSuccessToast({required context, required String? message}) {
    MotionToast toast = MotionToast.success(
      width: MediaQuery.of(context).size.width * .90,
      height: 70.0,
      title: const Text(
        'Success',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(
        '$message',
        style: const TextStyle(fontSize: 12),
      ),
      layoutOrientation: ToastOrientation.ltr,
      animationType: AnimationType.fromBottom,
      dismissable: true,
      position: MotionToastPosition.top,
    );
    toast.show(context);
    Future.delayed(const Duration(seconds: 4)).then((value) {
      toast.dismiss();
    });
  }

  void showErrorToast({required context, required String? message}) {
    MotionToast.error(
      title: const Text(
        'Error',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text('$message'),
      position: MotionToastPosition.top,
      barrierColor: Colors.black.withOpacity(0.3),
      width: 300,
      height: 80,
      dismissable: false,
    ).show(context);
  }
}
