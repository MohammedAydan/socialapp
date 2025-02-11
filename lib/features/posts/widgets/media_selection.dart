import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pro_image_editor/features/main_editor/main_editor.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:socialapp/features/posts/controllers/posts_controller.dart';
import 'package:socialapp/features/posts/widgets/add_media_btn.dart';
import 'package:socialapp/widgets/custom_text_form_feild.dart';

class MediaSelection extends StatelessWidget {
  const MediaSelection({super.key, required this.controller});
  final PostsController controller;

  @override
  Widget build(BuildContext context) {
    bool isPluseOrBasicPlan = true;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        child: Obx(
          () => (controller.filePath.value.isNotEmpty &&
                  controller.fileType.value.isNotEmpty)
              ? const SizedBox()
              : SingleChildScrollView(
                
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAddMediaBtn(
                        icon: Icons.perm_media_outlined,
                        onPressed: () => _pickImage(ImageSource.gallery),
                      ),
                      const SizedBox(width: 10),
                      _buildAddMediaBtn(
                        icon: Icons.camera,
                        onPressed: () => _pickImage(ImageSource.camera),
                      ),
                      const SizedBox(width: 10),
                      _buildAddMediaBtn(
                        icon: Icons.link_rounded,
                        onPressed: _showEmbedDialog,
                      ),
                      const SizedBox(width: 10),
                      _buildAddMediaBtn(
                        icon: Icons.video_collection_rounded,
                        onPressed: () =>
                            _pickAndValidateFile(FileType.video, "video"),
                        access: isPluseOrBasicPlan,
                      ),
                      const SizedBox(width: 10),
                      _buildAddMediaBtn(
                        icon: Icons.audio_file_rounded,
                        onPressed: () =>
                            _pickAndValidateFile(FileType.audio, "audio"),
                        access: isPluseOrBasicPlan,
                      ),
                      const SizedBox(width: 10),
                      _buildAddMediaBtn(
                        icon: Icons.file_present_rounded,
                        onPressed: () => _pickAndValidateFile(
                          FileType.custom,
                          "file",
                          allowedExtensions: [
                            "pdf",
                            "doc",
                            "docx",
                            "ppt",
                            "pptx",
                            "xls",
                            "xlsx",
                            "txt",
                            "rtf",
                            "zip",
                            "rar",
                            "7z",
                            "tar",
                            "gz"
                          ],
                        ),
                        access: isPluseOrBasicPlan,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildAddMediaBtn({
    required IconData icon,
    required VoidCallback onPressed,
    bool access = true,
  }) {
    return AddMediaBtn(
      access: access,
      icon: icon,
      onPressed: onPressed,
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await controller.imagePickerRepository.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (file != null) {
      Get.to(() => _proImageEditor(file));
    }
  }

  Future<void> _pickAndValidateFile(
    FileType type,
    String textType, {
    List<String>? allowedExtensions,
  }) async {
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

        double fileSizeInMB = await _getFileSize(file);
        controller.fileSize(fileSizeInMB);

        if (fileSizeInMB > 50) {
          Get.snackbar(
            "Error",
            "File size exceeds 50 MB limit.",
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          controller.filePath(path);
          controller.fileType(fileType);
        }
      }
    }
  }

  Widget _proImageEditor(XFile path) {
    return ProImageEditor.file(
      File(path.path),
      callbacks: ProImageEditorCallbacks(
        onImageEditingComplete: (Uint8List image) async {
          String imagePath = await _saveImageToFile(image);
          controller.filePath(imagePath);
          controller.fileType("image");
        },
        onCloseEditor: () {
          Get.back();
        },
      ),
    );
  }

  Future<String> _saveImageToFile(Uint8List image) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = "${tempDir.path}/${DateTime.now().toIso8601String()}.jpg";
    final tempImage = File(tempPath);
    await tempImage.writeAsBytes(image);
    return tempImage.path;
  }

  Future<double> _getFileSize(File file) async {
    int fileSizeInBytes = await file.length();
    double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    return fileSizeInMB;
  }

  void _showEmbedDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Get.theme.colorScheme.tertiary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        title: const Text(
          "Add embedded link or embed code",
          style: TextStyle(fontSize: 15),
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
            onPressed: _addEmbed,
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _addEmbed() {
    if (controller.embedText.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Embed text cannot be empty.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    String? extractedUrl;

    if (controller.embedText.value.contains('<iframe') &&
        controller.embedText.value.contains('src="')) {
      final splitText = controller.embedText.value.split('src="');
      if (splitText.length > 1) {
        extractedUrl = splitText[1].split('"')[0];
      }
    } else {
      extractedUrl = controller.embedText.value;
    }

    if (extractedUrl == null ||
        !RegExp(r'^(http|https):\/\/').hasMatch(extractedUrl)) {
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
      Get.snackbar(
        "Error",
        "Embed text contains an invalid URL.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    controller.filePath(extractedUrl);
    controller.fileType("embedded");

    controller.embedText("");
    Get.back();
  }
}
