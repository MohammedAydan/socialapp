import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:socialapp/features/posts/controllers/post_controller.dart';
import 'package:socialapp/features/posts/models/post_model.dart';
import 'package:socialapp/global/pages/custom_browser.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FileWidget extends StatelessWidget {
  const FileWidget({
    super.key,
    required this.controller,
    required this.post,
  });

  final PostController controller;
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: () async {
                // await launchUrlString(post.mediaUrl!);
                Get.to(() => CustomBrowser(url: post.mediaUrl!));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.file_present),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.mediaName ?? "File name",
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                post.mediaName?.split(".").last ?? "File type",
                                style: TextStyle(
                                  color: context.theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "${NumberFormat.decimalPattern().format(post.mediaSize)} MB",
                          style: TextStyle(
                            color: context.theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              downloadFile();
              // show snickbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("downloading".tr),
                  backgroundColor: context.theme.colorScheme.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.file_download_rounded),
          ),
        ],
      ),
    );
  }

  void downloadFile() async {
    await FlutterDownloader.enqueue(
      url: post.mediaUrl!,
      savedDir: "/",
      showNotification: true,
      openFileFromNotification: true,
      fileName: post.mediaName,
      saveInPublicStorage: true,
    );
  }
}
