import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/posts/controllers/posts_controller.dart';
import 'package:socialapp/widgets/error_card.dart';
import '../widgets/bottom_nav_bar_for_add_post.dart';
import '../widgets/media_selection.dart';
import '../widgets/show_media.dart';

class AddPostScreen extends GetView<PostsController> {
  static const String routeName = "/AddPost";
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add_post".tr),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: context.theme.colorScheme.onSurface),
        titleTextStyle: TextStyle(
          color: context.theme.colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              if (controller.error.value.isNotEmpty) {
                return Column(
                  children: [
                    ErrorCard(error: controller.error.value),
                    const SizedBox(height: 10),
                  ],
                );
              }
              return const SizedBox();
            }),
            const SizedBox(height: 10),
            MediaSelection(controller: controller),
            const SizedBox(height: 20),
            TextFormField(
              onChanged: (v) => controller.titlePost(v),
              decoration: InputDecoration(
                labelText: "enter_your_post_title".tr,
                labelStyle: TextStyle(
                  color: context.theme.colorScheme.secondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: context.theme.colorScheme.surface,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              onChanged: (v) => controller.bodyPost(v),
              maxLength: 5000,
              maxLines: null,
              minLines: 2,
              decoration: InputDecoration(
                labelText: "enter_your_post_text".tr,
                labelStyle: TextStyle(
                  color: context.theme.colorScheme.secondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: context.theme.colorScheme.surface,
              ),
            ),
            const SizedBox(height: 20),
            ShowMedia(controller: controller),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBarForAddPost(controller: controller),
    );
  }
}
