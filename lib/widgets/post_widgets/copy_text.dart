import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<void> copyText(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: context.theme.colorScheme.primary,
      content: Text("text_copied_to_clipboard".tr),
    ),
  );
}
