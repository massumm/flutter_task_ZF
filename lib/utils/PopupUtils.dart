import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopupUtils {
  static void showPopup(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text('Dialog'),
        content: Text(message), // Use the message parameter here
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Get.back(),
          ),
        ],
      )// Provide the context here
    );
  }
}
