import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:path/path.dart';
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
      decoration: BoxDecoration(
        color: context.theme.colorScheme.tertiary,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          width: 1,
          color: context.theme.colorScheme.secondary,
        ),
      ),
      child: Stack(
        children: [
          IconButton(
            onPressed: access == true
                ? onPressed
                : () {
                    Get.to(() => Plans());
                    // Get.defaultDialog(
                    //   titlePadding: const EdgeInsets.all(20),
                    //   contentPadding: const EdgeInsets.only(
                    //     left: 20,
                    //     right: 20,
                    //     bottom: 20,
                    //   ),
                    //   title: "no_access".tr,
                    //   content: Column(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         "no_access_message".tr,
                    //       ),
                    //       const SizedBox(height: 10),
                    //       Container(
                    //         padding: const EdgeInsets.all(10),
                    //         decoration: BoxDecoration(
                    //           color: context.theme.colorScheme.surface,
                    //           borderRadius: BorderRadius.circular(10),
                    //         ),
                    //         child: InkWell(
                    //           onTap: () {
                    //             Clipboard.setData(
                    //               ClipboardData(text: phoneNumber),
                    //             );
                    //             Get.back();
                    //             ScaffoldMessenger.of(context).showSnackBar(
                    //               SnackBar(
                    //                 content: Text(
                    //                   "text_copied_to_clipboard".tr,
                    //                 ),
                    //                 behavior: SnackBarBehavior.floating,
                    //                 backgroundColor:
                    //                     context.theme.colorScheme.primary,
                    //               ),
                    //             );
                    //           },
                    //           child: Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               Text(
                    //                 phoneNumber,
                    //                 style: const TextStyle(
                    //                   fontWeight: FontWeight.w600,
                    //                 ),
                    //               ),
                    //               const Icon(Icons.copy_rounded),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       const SizedBox(height: 20),
                    //       Center(
                    //         child: Text(
                    //           "subscription_message".tr,
                    //           style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             color: context.theme.colorScheme.primary,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    //   // middleText: "You don't have access to this feature",
                    //   buttonColor: context.theme.colorScheme.secondary,
                    //   backgroundColor: context.theme.colorScheme.tertiary,
                    //   actions: [
                    //     CustomPrimaryButton(
                    //       text: "cancel".tr,
                    //       onPressed: () => Get.back(),
                    //     ),
                    //   ],
                    // );
                  },
            icon: Icon(
              icon,
              color: context.theme.colorScheme.secondary,
            ),
          ),
          if (access == false)
            Positioned(
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.secondary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.lock,
                  color: context.theme.colorScheme.tertiary,
                  size: 17,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
