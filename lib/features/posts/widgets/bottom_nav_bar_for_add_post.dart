import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/posts/controllers/posts_controller.dart';
import 'package:socialapp/features/posts/models/post_model.dart';
import 'package:socialapp/main.dart';
import 'package:socialapp/widgets/custom_primary_button.dart';

class BottomNavBarForAddPost extends StatelessWidget {
  const BottomNavBarForAddPost({super.key, required this.controller});

  final PostsController controller;

  @override
  Widget build(BuildContext context) {
    PostModel? post = (Get.arguments is PostModel) ? Get.arguments : null;

    return Container(
      width: double.infinity,
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Get.theme.colorScheme.surface.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Obx(() {
              return DropdownButtonFormField<String>(
                value: controller.publicPost.value ? "public" : "private",
                dropdownColor: context.theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(15),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: context.theme.colorScheme.surface,
                ),
                items: [
                  DropdownMenuItem(value: "public", child: Text("Public".tr)),
                  DropdownMenuItem(value: "private", child: Text("Private".tr)),
                ],
                onChanged: (v) {
                  controller.publicPost(v == "public");
                },
              );
            }),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 150,
            child: Obx(() {
              final isButtonEnabled = controller.titlePost.value.isNotEmpty ||
                  controller.bodyPost.isNotEmpty ||
                  (controller.filePath.value.isNotEmpty &&
                      controller.fileType.value.isNotEmpty) ||
                  post != null;
              return CustomPrimaryButton(
                text: "Post".tr,
                onPressed: !isButtonEnabled
                    ? null
                    : () {
                        controller.addPost(
                          PostModel(
                            userId: supabase.auth.currentUser?.id,
                            title: controller.titlePost.value,
                            body: controller.bodyPost.value,
                            public: controller.publicPost.value,
                            mediaType: controller.fileType.value,
                            mediaUrl: controller.filePath.value,
                            sharingPostId: post?.postId,
                          ),
                        );
                      },
              );
            }),
          )
        ],
      ),
    );
  }
}
