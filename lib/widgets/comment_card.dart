import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/posts/controllers/show_post_controller.dart';
import 'package:socialapp/features/posts/models/comment_model.dart';
import 'package:socialapp/features/user_profile/pages/user_profile_screen.dart';
import 'package:socialapp/main.dart';
import 'package:socialapp/widgets/user_image.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    super.key,
    required this.comment,
    required this.controller,
  });
  final CommentModel comment;
  final ShowPostController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.tertiary,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  if (comment.userId != null &&
                      comment.userId != supabase.auth.currentUser?.id) {
                    Get.toNamed(
                      UserProfileScreen.routeName,
                      arguments: comment.userId,
                    );
                  }
                },
                child: Row(
                  children: [
                    if (comment.imageUrl != null) ...[
                      UserImage(
                        url: comment.imageUrl!,
                        radius: 20,
                      ),
                    ] else ...[
                      CircleAvatar(
                        child: Center(
                          child: Text(comment.username != null
                              ? comment.username![0].toUpperCase()
                              : ""),
                        ),
                      ),
                    ],
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${comment.username}"),
                        const SizedBox(width: 10),
                        Text(
                          DateTimeFormat.relative(
                            comment.createdAt!.toLocal(),
                            ifNow: "now",
                          ),
                          style: TextStyle(
                            color: context.theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (comment.userId == supabase.auth.currentUser?.id) ...[
                SizedBox(
                  child: IconButton(
                    onPressed: () => controller.removeComment(comment.id ?? 0),
                    icon: Icon(
                      Icons.delete_rounded,
                      color: context.theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Text("${comment.comment}"),
        ],
      ),
    );
  }
}
