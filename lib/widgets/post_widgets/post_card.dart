import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/di/di.dart';
import 'package:socialapp/features/posts/controllers/post_controller.dart';
import 'package:socialapp/features/posts/models/post_model.dart';
import 'package:socialapp/features/posts/pages/show_post_screen.dart';
import 'post_actions.dart';
import 'post_body.dart';
import 'post_media.dart';
import 'post_title.dart';
import 'post_user_info.dart';
import 'shared_post.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    this.postSharing = false,
  });

  final PostModel post;
  final bool? postSharing;

  @override
  Widget build(BuildContext context) {
    final PostController controller = Get.put(
      PostController(sl(), sl(), sl(), Get.find(), Get.find(), post),
      tag: post.postId.toString(),
    );

    return GestureDetector(
      onTap: () {
        if (postSharing == true) {
          Get.toNamed(ShowPostScreen.routeName, arguments: post);
        }
      },
      child: Container(
        color: context.theme.colorScheme.tertiary,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostUserInfo(
              post: post,
              postController: controller,
              postSharing: postSharing!,
            ),
            if (post.title?.isNotEmpty ?? false)
              PostTitle(post: post, controller: controller),
            if (post.body?.isNotEmpty ?? false)
              PostBody(post: post, controller: controller),
            PostMedia(controller: controller, post: post),
            if (post.sharingPostId != null) SharedPost(controller: controller),
            const SizedBox(height: 10),
            if (!postSharing!) ...[
              if (!post.myNewPost!) ...[
                Divider(color: context.theme.colorScheme.surface),
                const SizedBox(height: 2),
                PostActions(
                  context: context,
                  controller: controller,
                  post: post,
                ),
              ]
            ],
          ],
        ),
      ),
    );
  }
}
