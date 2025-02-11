import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/posts/controllers/post_controller.dart';
import 'package:socialapp/features/posts/models/post_model.dart';
import 'package:socialapp/global/pages/show_image.dart';
import 'package:socialapp/widgets/audio_player_widget.dart';
import 'package:socialapp/widgets/custom_image.dart';
import 'package:socialapp/widgets/file_widget.dart';
import 'package:socialapp/widgets/video_player_widget.dart';
import 'package:socialapp/features/posts/pages/web_view.dart';

class PostMedia extends StatelessWidget {
  const PostMedia({
    super.key,
    required this.controller,
    required this.post,
  });

  final PostController controller;
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    if (post.mediaType == "embedded" &&
        post.mediaUrl != null &&
        post.mediaUrl!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: buildVideoWidget(post.mediaUrl!),
      );
    }
    if (post.mediaType?.isNotEmpty == true) {
      if (post.mediaType!.contains("video") && post.mediaUrl != null) {
        return Column(
          children: [
            const SizedBox(height: 10),
            VideoPlayerWidget(
              controller: controller,
              url: post.mediaUrl!,
            ),
          ],
        );
      } else if (post.mediaType!.contains("image") && post.mediaUrl != null) {
        return Column(
          children: [
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Get.to(
                  () => const ShowImage(),
                  arguments: post.mediaUrl,
                  transition: Transition.circularReveal,
                );
              },
              child: CustomImage(url: post.mediaUrl!),
            ),
          ],
        );
      } else if (post.mediaType!.contains("audio") && post.mediaUrl != null) {
        return Column(
          children: [
            const SizedBox(height: 10),
            AudioPlayerWidget(
              controller: controller,
              url: Uri.parse(post.mediaUrl!),
            ),
          ],
        );
      } else if (post.mediaUrl != null) {
        return Column(
          children: [
            const SizedBox(height: 10),
            FileWidget(
              controller: controller,
              post: post,
            ),
          ],
        );
      }
    }
    return const SizedBox();
  }
}
