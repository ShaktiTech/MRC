import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrc/utils/mycolor.dart';

class ErrorSnackBar {
  void showToastWithIcon(String title, String message, Icon icon) {
    Get.snackbar(
      title,
      message,
      icon: icon,
      backgroundColor: MyColor.primaryColor,
      colorText: Colors.white,
      
     
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
