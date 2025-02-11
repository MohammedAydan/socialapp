import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:socialapp/features/posts/controllers/posts_controller.dart';
import 'package:socialapp/features/posts/pages/web_view.dart';
import 'package:socialapp/widgets/file_video_player_widget.dart';
import 'package:voice_message_package/voice_message_package.dart';

class ShowMedia extends StatelessWidget {
  const ShowMedia({
    super.key,
    required this.controller,
  });

  final PostsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.filePath.value.isNotEmpty &&
          controller.fileType.value.isNotEmpty) {
        return Stack(
          children: [
            Builder(
              builder: (context) {
                if (controller.fileType.value == "embedded" &&
                    controller.filePath.value.isNotEmpty) {
                  return buildVideoWidget(controller.filePath.value);
                }
                if (controller.fileType.value == "image") {
                  return Image.file(File(controller.filePath.value));
                } else if (controller.fileType.value == "audio") {
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.only(
                          top: 70,
                          left: 10,
                          right: 10,
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: context.theme.colorScheme.tertiary,
                        ),
                        child: VoiceMessageView(
                          circlesColor: context.theme.colorScheme.primary,
                          // backgroundColor: Colors.black,
                          activeSliderColor: context.theme.colorScheme.primary,
                          backgroundColor: context.theme.colorScheme.tertiary,
                          controller: VoiceController(
                            audioSrc: controller.filePath.value,
                            maxDuration: const Duration(seconds: 10),
                            isFile: true,
                            onComplete: () {},
                            onPause: () {},
                            onPlaying: () {},
                          )..init(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: context.theme.colorScheme.tertiary,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(controller.filePath.value.split("/").last),
                            const SizedBox(height: 5),
                            showFileSize(controller.fileSize.value)
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (controller.fileType.value == "video") {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        FileVideoPlayerWidget(
                          path: controller.filePath.value,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: context.theme.colorScheme.tertiary,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(controller.filePath.value.split("/").last),
                              const SizedBox(height: 5),
                              showFileSize(controller.fileSize.value)
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (controller.fileType.value.isNotEmpty) {
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.only(
                          top: 70,
                          left: 10,
                          right: 10,
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: context.theme.colorScheme.tertiary,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.file_present),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.filePath
                                        .toString()
                                        .split("/")
                                        .last,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    controller.filePath
                                        .toString()
                                        .split(".")
                                        .last,
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
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: context.theme.colorScheme.tertiary,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(controller.filePath.value.split("/").last),
                            const SizedBox(height: 5),
                            showFileSize(controller.fileSize.value)
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: context.theme.colorScheme.secondary.withOpacity(0.3),
                ),
                child: IconButton(
                  onPressed: () {
                    controller.filePath("");
                    controller.fileType("");
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
            ),
          ],
        );
      }
      return const SizedBox();
    });
  }

  Widget showFileSize(double size) {
    return Text(
      "${NumberFormat.decimalPattern().format(size)} MB",
    );
  }
}
