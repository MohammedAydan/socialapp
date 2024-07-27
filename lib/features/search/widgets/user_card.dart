import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/auth/models/user_model.dart';
import 'package:socialapp/features/user_profile/pages/user_profile_screen.dart';
import 'package:socialapp/main.dart';
import 'package:socialapp/widgets/user_image.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (user.userId != supabase.auth.currentUser?.id) {
          Get.toNamed(UserProfileScreen.routeName, arguments: user.userId);
        }
      },
      child: Container(
        width: 300,
        height: 60,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: context.theme.colorScheme.tertiary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (user.imageUrl != null) ...[
                  UserImage(
                    radius: 20,
                    url: user.imageUrl!,
                  ),
                ] else ...[
                  CircleAvatar(
                    radius: 20,
                    child: Center(
                      child: Text("${user.username?[0].toUpperCase()}"),
                    ),
                  ),
                ],
                const SizedBox(width: 10),
                Text("${user.username}"),
              ],
            ),
            const Row(
              children: [
                // SizedBox(
                //   width: 90,
                //   height: 30,
                //   child: CustomPrimaryButton(text: "Follow", onPressed: () {}),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
