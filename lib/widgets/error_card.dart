import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({
    super.key,
    required this.error,
    this.color,
    this.textColor,
  });

  final String error;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color ??
            (Get.isDarkMode
                ? Colors.red.withOpacity(0.2)
                : Colors.red.withOpacity(0.1)),
      ),
      child: Text(
        error,
        style: TextStyle(
          color: textColor ?? Colors.red,
          fontSize: 16,
        ),
      ),
    );
  }
}
