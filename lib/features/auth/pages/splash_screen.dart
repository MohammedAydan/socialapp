import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/auth/controllers/auth_controller.dart';

class SplashScreen extends GetView<AuthController> {
  static const String routeName = "/";
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 6),
            Image.asset(
              "assets/icons/social-1.png",
              width: 100,
            ),
            const Spacer(flex: 4),
            const Text("Powerd By"),
            const SizedBox(height: 10),
            Text(
              "MAG",
              style: TextStyle(
                color: context.theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
