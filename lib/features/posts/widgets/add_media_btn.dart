import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class AddMediaBtn extends StatelessWidget {
  const AddMediaBtn({
    super.key,
    required this.icon,
    this.onPressed,
    this.access = false,
  });

  final IconData icon;
  final Callback? onPressed;
  final bool? access;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: context.theme.colorScheme.primary,
            width: 0.5,
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            color: context.theme.colorScheme.primary,
            size: 28,
          ),
        ),
      ),
    );
  }
}
