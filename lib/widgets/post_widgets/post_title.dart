import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:socialapp/features/posts/controllers/post_controller.dart';
import 'package:socialapp/features/posts/models/post_model.dart';
import 'package:socialapp/widgets/post_widgets/post_card.dart';

import 'copy_text.dart';

class PostTitle extends StatelessWidget {
  const PostTitle({
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
        InkWell(
          onTap: () {
            controller.handleToggleFullPost();
          },
          onLongPress: () => copyText(context, post.body ?? ""),
          child: MarkdownBody(data: post.title ?? ""),
        ),
      ],
    );
  }
}
