import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/posts/controllers/posts_controller.dart';
import 'package:socialapp/features/posts/models/post_model.dart';
import 'package:socialapp/features/posts/widgets/bottom_nav_bar_for_add_post.dart';
import 'package:socialapp/widgets/error_card.dart';
import 'package:socialapp/widgets/post_widgets/post_card.dart';

class SharePostScreen extends GetView<PostsController> {
  static const String routeName = "/SharePost";
  const SharePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("share_post".tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ObxValue((v) {
              if (controller.error.value.isNotEmpty) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ErrorCard(error: controller.error.value),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              }
              return const SizedBox();
            }, controller.error),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                child: TextFormField(
                  onChanged: (v) => controller.titlePost(v),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    label: Text(
                      "enter_your_post_title".tr,
                      style: TextStyle(
                        color: context.theme.colorScheme.secondary,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
            ),
            Divider(color: context.theme.colorScheme.tertiary, height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                child: TextFormField(
                  onChanged: (v) => controller.bodyPost(v),
                  maxLength: 5000,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    label: Text(
                      "enter_your_post_text".tr,
                      style: TextStyle(
                        color: context.theme.colorScheme.secondary,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (Get.arguments is PostModel) ...[
              Container(
                margin: const EdgeInsets.all(20),
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
                  post: Get.arguments,
                  postSharing: true,
                ),
              ),
            ],
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // AddMediaBtn(icon: Icons.perm_media_outlined),
                // SizedBox(width: 10),
                // AddMediaBtn(icon: Icons.camera),
                // SizedBox(width: 10),
                // AddMediaBtn(icon: Icons.audiotrack_outlined),
                // SizedBox(width: 10),
                // AddMediaBtn(icon: Icons.file_present_outlined),
                // SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBarForAddPost(controller: controller),
    );
  }
}
