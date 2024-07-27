import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:socialapp/di/di.dart';
import 'package:socialapp/features/posts/controllers/show_post_controller.dart';
import 'package:socialapp/widgets/custom_text_form_feild.dart';
import 'package:socialapp/widgets/error_card_and_refresh_button.dart';
import 'package:socialapp/widgets/loadings/post_loading.dart';
import 'package:socialapp/widgets/post_widgets/post_card.dart';
import '../../../../widgets/comment_card.dart';

class ShowPostScreen extends StatelessWidget {
  static const String routeName = "/ShowPost";
  ShowPostScreen({super.key});
  final ShowPostController controller = Get.put(ShowPostController(
    sl(),
    sl(),
    Get.find(),
  ));

  @override
  Widget build(BuildContext context) {
    final FocusNode commentFocusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "POST_TITLE".tr,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () {
          if (controller.isLoading.isTrue) {
            return const PostLoading();
          } else if (controller.error.isNotEmpty) {
            return Center(
              child: Text(controller.error.value),
            );
          } else {
            return ListView(
              controller: controller.scrollController,
              children: [
                PostCard(post: controller.post.value!),
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.tertiary,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(FontAwesome.comment_dots),
                      const SizedBox(width: 10),
                      Text("comments".tr),
                    ],
                  ),
                ),
                if (controller.errorComments.isNotEmpty) ...[
                  Center(
                    child: Text(controller.errorComments.value),
                  ),
                ],
                if (controller.loadingComments.isTrue) ...[
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ] else ...[
                  if (controller.comments.isEmpty) ...[
                    Center(
                      child: ErrorCardAndRefreshButton(
                        method: controller.getInitComments,
                        message: "not_found_any_comment".tr,
                      ),
                    ),
                  ],
                  ListView.builder(
                    itemCount: controller.comments.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) => CommentCard(
                      comment: controller.comments[i],
                      controller: controller,
                    ),
                  ),
                ],
                if (controller.loadingComments.isFalse &&
                    controller.loadingMoreComments.isTrue) ...[
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ]
              ],
            );
          }
        },
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        height: 90,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          color: Theme.of(context).colorScheme.tertiary,
        ),
        child: Row(
          children: [
            Obx(() {
              if (controller.error.value.isNotEmpty) {
                return Text(controller.error.value,
                    style: const TextStyle(color: Colors.red));
              }
              if (controller.loadingOpComment.isTrue) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (controller.comment.value.isNotEmpty) {
                return Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        controller.addComment();
                      },
                      icon: Icon(
                        Icons.send_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                );
              }
              return const SizedBox();
            }),
            Expanded(
              child: CustomTextFormFeild(
                label: "enter_comment".tr,
                onChanged: (v) => controller.comment(v),
                controller: controller.commentEditingController,
                focusNode: commentFocusNode,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
