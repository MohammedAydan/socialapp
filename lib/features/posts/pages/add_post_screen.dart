import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/posts/controllers/posts_controller.dart';
import 'package:socialapp/widgets/custom_text_buttom.dart';
import 'package:socialapp/widgets/error_card.dart';
import '../widgets/bottom_nav_bar_for_add_post.dart';
import '../widgets/media_selection.dart';
import '../widgets/show_media.dart';
import 'package:flutter_quill/flutter_quill.dart';

class AddPostScreen extends GetView<PostsController> {
  static const String routeName = "/AddPost";
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add_post".tr),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ObxValue((v) {
            if (controller.error.value.isNotEmpty) {
              return Column(
                children: [
                  ErrorCard(error: controller.error.value),
                  const SizedBox(height: 10),
                ],
              );
            }
            return const SizedBox();
          }, controller.error),
          const SizedBox(height: 10),
          MediaSelection(controller: controller),
          const SizedBox(height: 10),
          Divider(color: context.theme.colorScheme.tertiary, height: 1),
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
            child: Expanded(
              // width: double.infinity,
              child: TextFormField(
                onChanged: (v) => controller.bodyPost(v),
                maxLength: 5000,
                maxLines: null,
                minLines: 2,
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
          Divider(color: context.theme.colorScheme.tertiary, height: 1),
          const SizedBox(height: 10),
          ShowMedia(controller: controller),
          const SizedBox(height: 10),
          // Divider(color: context.theme.colorScheme.tertiary, height: 1),
          // //
          // SizedBox(
          //   width: double.infinity,
          //   child: QuillToolbar.simple(
          //     controller: controller.quillController,
          //   ),
          // ),
          // QuillEditor.basic(
          //   controller: controller.quillController,
          //   configurations: QuillEditorConfigurations(
          //     scrollable: false,
          //     scrollPhysics: NeverScrollableScrollPhysics(),
          //     padding: EdgeInsets.all(10),
          //     minHeight: 200,
          //     placeholder: "enter_your_post_text".tr,
          //   ),
          // ),
          // const SizedBox(height: 10),
        ],
      ),
      bottomNavigationBar: BottomNavBarForAddPost(controller: controller),
    );
  }
}
