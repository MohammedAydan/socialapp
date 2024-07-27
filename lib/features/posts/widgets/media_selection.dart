import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialapp/features/posts/controllers/posts_controller.dart';
import 'package:socialapp/features/posts/widgets/add_media_btn.dart';

class MediaSelection extends StatelessWidget {
  const MediaSelection({super.key, required this.controller});
  final PostsController controller;

  @override
  Widget build(BuildContext context) {
    bool isPluseOrBasicPlan =
        controller.authController.user.value?.basicPlan == true ||
            controller.authController.user.value?.plusPlan == true;
    return SizedBox(
      child: Obx(
        () => (controller.filePath.value.isNotEmpty &&
                controller.fileType.value.isNotEmpty)
            ? const SizedBox()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AddMediaBtn(
                    access: true,
                    icon: Icons.perm_media_outlined,
                    onPressed: () async {
                      final file =
                          await controller.imagePickerRepository.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (file != null) {
                        // controller.fileSize();
                        controller.fileSize(await getFileSize(File(file.path)));
                        controller.filePath(file.path);
                        controller.fileType("image");
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  AddMediaBtn(
                    access: true,
                    icon: Icons.camera,
                    onPressed: () async {
                      final file =
                          await controller.imagePickerRepository.pickImage(
                        source: ImageSource.camera,
                      );
                      if (file != null) {
                        controller.fileSize(await getFileSize(File(file.path)));
                        controller.filePath(file.path);
                        controller.fileType("image");
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  AddMediaBtn(
                    access: isPluseOrBasicPlan,
                    icon: Icons.video_collection_rounded,
                    onPressed: () =>
                        pickAndValidateFile(FileType.video, "video"),
                  ),
                  const SizedBox(width: 10),
                  AddMediaBtn(
                    access: isPluseOrBasicPlan,
                    icon: Icons.audio_file_rounded,
                    onPressed: () =>
                        pickAndValidateFile(FileType.audio, "audio"),
                  ),
                  const SizedBox(width: 10),
                  AddMediaBtn(
                    access: isPluseOrBasicPlan,
                    icon: Icons.file_present_rounded,
                    onPressed: () => pickAndValidateFile(
                        FileType.custom, "file",
                        allowedExtensions: [
                          // Documents
                          "pdf",
                          "doc",
                          "docx",
                          "ppt",
                          "pptx",
                          "xls",
                          "xlsx",
                          "txt",
                          "rtf",
                          // Archives
                          "zip",
                          "rar",
                          "7z",
                          "tar",
                          "gz"
                        ]),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> pickAndValidateFile(
    FileType type,
    String textType, {
    List<String>? allowedExtensions,
  }) async {
    // Pick the file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: type,
      allowedExtensions: allowedExtensions,
    );

    if (result != null) {
      String? path = result.files.first.path;
      String fileType = textType;

      if (fileType == "file") {
        fileType = "file.${path!.split(".").last}";
      }

      if (path != null) {
        File file = File(path);

        double fileSizeInMB = await getFileSize(file);
        controller.fileSize(fileSizeInMB);

        // Check if file size exceeds 50 MB
        if (fileSizeInMB > 50) {
          Get.snackbar(
            "Error",
            "File size exceeds 50 MB limit.",
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          // File size is within the acceptable limit
          controller.filePath(path);
          controller.fileType(fileType);
        }
      }
    }
  }

  Future<double> getFileSize(File file) async {
    int fileSizeInBytes = await file.length();
    double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    return fileSizeInMB;
  }
}
