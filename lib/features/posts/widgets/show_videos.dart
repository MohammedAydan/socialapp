import 'package:flutter/material.dart';
import 'package:socialapp/features/posts/controllers/videos_posts_controller.dart';
import 'package:socialapp/features/posts/models/post_model.dart';
import 'package:socialapp/widgets/post_widgets/post_card.dart';

class ShowVideos extends StatelessWidget {
  const ShowVideos({
    super.key,
    required this.maxWidth,
    required this.controller,
  });

  final double? maxWidth;
  final VideosPostsController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: maxWidth != null ? const EdgeInsets.all(20) : null,
      itemCount: controller.posts.length,
      itemBuilder: (context, i) {
        PostModel post = controller.posts[i];
        return Center(
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxWidth: maxWidth ?? double.infinity,
            ),
            child: PostCard(post: post),
          ),
        );
      },
    );
  }
}
