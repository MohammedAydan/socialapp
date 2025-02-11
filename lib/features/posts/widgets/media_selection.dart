import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialapp/features/posts/controllers/posts_controller.dart';
import 'package:socialapp/features/posts/widgets/add_media_btn.dart';
import 'package:socialapp/widgets/custom_text_form_feild.dart';

class MediaSelection extends StatelessWidget {
  const MediaSelection({super.key, required this.controller});
  final PostsController controller;

  @override
  Widget build(BuildContext context) {
    // bool isPluseOrBasicPlan =
    //     controller.authController.user.value?.basicPlan == true ||
    //         controller.authController.user.value?.plusPlan == true;
    bool isPluseOrBasicPlan = true;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
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
                          imageQuality: 85,
                        );
                        if (file != null) {
                          // controller.fileSize();
                          controller
                              .fileSize(await getFileSize(File(file.path)));
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
                          imageQuality: 85,
                        );
                        if (file != null) {
                          controller
                              .fileSize(await getFileSize(File(file.path)));
                          controller.filePath(file.path);
                          controller.fileType("image");
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                    AddMediaBtn(
                      access: true,
                      icon: Icons.link_rounded,
                      onPressed: () {
                        Get.dialog(
                          AlertDialog(
                            backgroundColor: context.theme.colorScheme.tertiary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            actionsAlignment: MainAxisAlignment.spaceBetween,
                            title: const Text(
                              "Add embedded link or embed code",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            content: CustomTextFormFeild(
                              label: "Enter link or embed code",
                              textInputType: TextInputType.text,
                              onChanged: (v) {
                                controller.embedText(v);
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  controller.embedText("");
                                  Get.back();
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (controller.embedText.value.isEmpty) {
                                    // Show an error if the input is empty
                                    Get.snackbar(
                                      "Error",
                                      "Embed text cannot be empty.",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

// Allow both iframe and regular HTTP/HTTPS URLs
                                  String? extractedUrl;

// Check if the embed text contains an iframe tag with a valid src attribute
                                  if (controller.embedText.value
                                          .contains('<iframe') &&
                                      controller.embedText.value
                                          .contains('src="')) {
                                    // Extract the URL from the src attribute
                                    final splitText = controller.embedText.value
                                        .split('src="');
                                    if (splitText.length > 1) {
                                      extractedUrl = splitText[1].split('"')[0];
                                    }
                                  } else {
                                    // If it's not an iframe, treat it as a direct URL
                                    extractedUrl = controller.embedText.value;
                                  }

// Validate the extracted URL
                                  if (extractedUrl == null ||
                                      !RegExp(r'^(http|https):\/\/')
                                          .hasMatch(extractedUrl)) {
                                    Get.snackbar(
                                      "Error",
                                      "Embed text must contain a valid iframe or HTTP/HTTPS URL.",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  if (!Uri.tryParse(extractedUrl)!.isAbsolute) {
                                    // Show an error if the extracted URL is not well-formed
                                    Get.snackbar(
                                      "Error",
                                      "Embed text contains an invalid URL.",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

// If all validations pass, set the filePath and fileType
                                  controller.filePath(extractedUrl);
                                  controller.fileType("embedded");

// Clear the embed text and close the dialog
                                  controller.embedText("");
                                  Get.back();
                                },
                                child: const Text("Add"),
                              ),
                            ],
                          ),
                        );
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
      compressionQuality: 85,
      allowCompression: true,
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
