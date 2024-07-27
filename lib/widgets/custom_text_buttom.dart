import 'package:flutter/material.dart';

class CustomTextButtom extends StatelessWidget {
  const CustomTextButtom({
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
      child: TextButton(
        style: TextButton.styleFrom(),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
