import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/widgets/error_card.dart';

class SignoutScreen extends StatelessWidget {
  static const String routeName = "/Signout";
  const SignoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/icons/social.png",
              width: 35,
              height: 35,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ErrorCard(
            error: "logout_msg_successfull".tr,
            color: context.theme.colorScheme.tertiary,
            textColor: context.theme.colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
