import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/posts/controllers/posts_controller.dart';
import 'package:socialapp/features/posts/models/post_model.dart';
import 'package:socialapp/widgets/error_card_and_refresh_button.dart';
import 'package:socialapp/widgets/loadings/post_loading.dart';
import 'package:socialapp/widgets/post_widgets/post_card.dart';

class ShowPosts extends StatelessWidget {
  const ShowPosts({
    super.key,
    required this.controller,
    required this.maxWidth,
  });

  final PostsController controller;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loadingPosts.value) {
        return ListView.builder(
          itemCount: 10,
          padding: EdgeInsets.only(top: 75),
          itemBuilder: (context, index) => const PostLoading(),
        );
      }
      if (controller.posts.isEmpty && !controller.loadingPosts.value) {
        return ErrorCardAndRefreshButton(
          method: controller.getInitPosts,
          message: "no_posts_found".tr,
        );
      }

      return ListView(
        controller: controller.scrollController,
        children: [
          SizedBox(
            height: 75,
          ),
          ListView.builder(
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
          ),
          ObxValue((v) {
            if (controller.loadingMorePosts.isTrue) {
              return const PostLoading();
            }
            return const SizedBox();
          }, controller.loadingMorePosts),
        ],
      );
    });
  }
}
