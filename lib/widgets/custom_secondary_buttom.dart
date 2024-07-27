import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSecondaryButtom extends StatelessWidget {
  const CustomSecondaryButtom({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
  });
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: context.theme.colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: context.theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
