import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/posts/controllers/post_controller.dart';
import 'package:socialapp/features/posts/models/post_model.dart';
import 'package:socialapp/widgets/error_card.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'copy_text.dart';
import 'package:url_launcher/url_launcher.dart';

class PostBody extends StatelessWidget {
  const PostBody({
    super.key,
    required this.post,
    required this.controller,
  });

  final PostModel post;
  final PostController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
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
        Obx(() {
          // return getHtmlOrMarkdownWidget(
          //   post.body,
          //   controller,
          // );
          if (controller.showFullPost.isTrue) {
            return InkWell(
              onTap: () {
                controller.handleToggleFullPost();
              },
              onLongPress: () => copyText(context, post.body ?? ""),
              child: MarkdownBody(
                selectable: false,
                data: post.body ?? "",
              ),
            );
          } else {
            return Column(
              children: [
                if (post.body!.length > 500)
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          controller.handleToggleFullPost();
                        },
                        onLongPress: () => copyText(context, post.body ?? ""),
                        child: MarkdownBody(
                          selectable: false,
                          data: post.body!.length > 500
                              ? "${post.body!.substring(0, 500)} ..."
                              : post.body ?? "",
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            controller.handleToggleFullPost();
                          },
                          child: Text("show_more".tr),
                        ),
                      ),
                    ],
                  )
                else
                  InkWell(
                    onTap: () {
                      controller.handleToggleFullPost();
                    },
                    onLongPress: () => copyText(context, post.body ?? ""),
                    child: MarkdownBody(
                      selectable: false,
                      data: post.body ?? "",
                      onTapLink: (text, href, title) async {
                        if (href != null && await canLaunchUrlString(href)) {
                          await launchUrlString(href);
                        }
                      },
                    ),
                  ),
              ],
            );
          }
        }),
      ],
    );
  }
}
