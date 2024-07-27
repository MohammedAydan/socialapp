import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomPrimaryButton extends StatelessWidget {
  const CustomPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.bgColor,
    this.textColor,
    this.radius,
  });
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color? bgColor;
  final Color? textColor;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor ?? context.theme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 15),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? context.theme.colorScheme.tertiary,
          ),
        ),
      ),
    );
  }
}
