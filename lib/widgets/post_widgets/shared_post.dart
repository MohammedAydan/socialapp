import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/posts/controllers/post_controller.dart';
import 'package:socialapp/widgets/loadings/post_loading.dart';
import 'package:socialapp/widgets/post_widgets/post_card.dart';

class SharedPost extends StatelessWidget {
  const SharedPost({
    super.key,
    required this.controller,
  });

  final PostController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Obx(() {
          if (controller.isLoading.isTrue) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: context.theme.colorScheme.surface,
                ),
              ),
              child: const PostLoading(),
            );
          } else if (controller.postShareing.value != null) {
            return Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: context.theme.colorScheme.surface,
                ),
                borderRadius: BorderRadius.circular(12),
                color: context.theme.colorScheme.tertiary,
              ),
              child: PostCard(
                post: controller.postShareing.value!,
                postSharing: true,
              ),
            );
          }
          return const SizedBox();
        }),
      ],
    );
  }
}
