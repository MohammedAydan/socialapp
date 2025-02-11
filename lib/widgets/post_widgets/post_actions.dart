import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:socialapp/core/formatNumber/format_number.dart';
import 'package:socialapp/features/posts/controllers/post_controller.dart';
import 'package:socialapp/features/posts/models/post_model.dart';
import 'package:socialapp/features/posts/pages/share_post_screen.dart';
import 'package:socialapp/features/posts/pages/show_likes_screen.dart';
import 'package:socialapp/features/posts/pages/show_post_screen.dart';
import 'package:socialapp/features/posts/pages/show_shareings_screen.dart';

class PostActions extends StatelessWidget {
  const PostActions({
    super.key,
    required this.context,
    required this.controller,
    required this.post,
  });

  final BuildContext context;
  final PostController controller;
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return betaCode();
  }

  Widget betaCode() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.toNamed(ShowLikesScreen.routeName,
                      arguments: post.postId);
                },
                child: _buildActionItem(
                  controller.post.value?.likesCount.toInt() ?? 0,
                  FontAwesome.heart,
                  FontAwesome.heart_solid,
                  controller.post.value?.isLikes == true,
                  () {
                    controller.addOrRemoveLike();
                  },
                ),
              ),
            ),
            Expanded(
              child: _buildActionItem(
                controller.post.value?.commentsCount.toInt() ?? 0,
                FontAwesome.comment_dots,
                FontAwesome.comment_dots,
                false,
                () {
                  Get.toNamed(
                    ShowPostScreen.routeName,
                    arguments: post,
                  );
                },
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.toNamed(ShowShareingsScreen.routeName,
                      arguments: post.postId);
                },
                child: _buildActionItem(
                  controller.post.value?.sharingsCount.toInt() ?? 0,
                  FontAwesome.share_solid,
                  FontAwesome.share_solid,
                  false,
                  () {
                    Get.toNamed(
                      SharePostScreen.routeName,
                      arguments: controller.post.value,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget finalCode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildActionItem(
                controller.post.value?.likesCount.toInt() ?? 0,
                FontAwesome.heart,
                FontAwesome.heart_solid,
                controller.post.value?.isLikes == true,
                () {
                  controller.addOrRemoveLike();
                },
              ),
              _buildActionItem(
                controller.post.value?.commentsCount.toInt() ?? 0,
                FontAwesome.comment_dots,
                FontAwesome.comment_dots,
                false,
                () {
                  Get.toNamed(
                    ShowPostScreen.routeName,
                    arguments: post,
                  );
                },
              ),
              _buildActionItem(
                controller.post.value?.sharingsCount.toInt() ?? 0,
                FontAwesome.share_solid,
                FontAwesome.share_solid,
                false,
                () {
                  Get.toNamed(
                    SharePostScreen.routeName,
                    arguments: controller.post.value,
                  );
                },
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            FontAwesome.bookmark,
            color: context.theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem(
    int count,
    IconData icon,
    IconData activeIcon,
    bool isActive,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        Text(
          formatNumber(count),
          style: TextStyle(
            color: context.theme.colorScheme.secondary,
          ),
        ),
        Container(
          margin: const EdgeInsets.all(5),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Get.isDarkMode
                ? context.theme.colorScheme.secondary.withOpacity(0.03)
                : context.theme.colorScheme.secondary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              isActive ? activeIcon : icon,
              color: isActive
                  ? context.theme.colorScheme.primary
                  : context.theme.colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
