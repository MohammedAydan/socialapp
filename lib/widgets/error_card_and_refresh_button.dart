import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:socialapp/widgets/custom_primary_button.dart';

class ErrorCardAndRefreshButton extends StatelessWidget {
  const ErrorCardAndRefreshButton({
    super.key,
    required this.method,
    this.message,
    this.btnText,
  });

  final String? message;
  final String? btnText;
  final Callback method;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message ??
                "a_error_occurred._Please_check_your_internet_connection".tr,
          ),
          const SizedBox(height: 20),
          CustomPrimaryButton(
            text: btnText ?? "refresh".tr,
            onPressed: () {
              method();
            },
          ),
        ],
      ),
    );
  }
}
