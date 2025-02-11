import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:socialapp/global/pages/plans.dart';
import 'package:socialapp/widgets/custom_primary_button.dart';

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
    String phoneNumber = "01153200999";
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          IconButton(
            onPressed: access == true
                ? onPressed
                : () {
                    Get.to(() => Plans());
                  },
            icon: Icon(
              icon,
              color: context.theme.colorScheme.primary,
              size: 24,
            ),
          ),
          if (access == false)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
