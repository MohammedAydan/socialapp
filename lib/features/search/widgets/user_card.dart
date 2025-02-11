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
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: context.theme.colorScheme.tertiary,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            if (user.imageUrl != null) ...[
              UserImage(
                radius: 30,
                url: user.imageUrl!,
              ),
            ] else ...[
              CircleAvatar(
                radius: 30,
                child: Center(
                  child: Text(
                    "${user.username?[0].toUpperCase()}",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user.username}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios,
                  color: context.theme.colorScheme.primary),
              onPressed: () {
                if (user.userId != supabase.auth.currentUser?.id) {
                  Get.toNamed(UserProfileScreen.routeName,
                      arguments: user.userId);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
