import 'package:employee_management/app/ui/widgets/common/common_text.dart';
import 'package:flutter/material.dart';

class Utils {
  static void showSnackBar(String message, BuildContext context,
      {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CommonText(
          text: message,
          fontColor: Colors.white,
        ),
        backgroundColor: color,
      ),
    );
  }
}
