import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:socialapp/features/posts/controllers/posts_controller.dart';
import 'package:socialapp/features/posts/widgets/add_media_btn.dart';
import 'package:socialapp/widgets/custom_text_form_feild.dart';
import 'package:socialapp/widgets/loading.dart';

class MediaSelection extends StatelessWidget {
  const MediaSelection({super.key, required this.controller});
  final PostsController controller;

  @override
  Widget build(BuildContext context) {
    bool isPluseOrBasicPlan = true;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Obx(
        () => controller.filePath.value.isNotEmpty &&
                controller.fileType.value.isNotEmpty
            ? const SizedBox()
            : Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAddMediaBtn(Icons.perm_media_outlined,
                          () => _pickImage(ImageSource.gallery)),
                      _buildAddMediaBtn(
                          Icons.camera, () => _pickImage(ImageSource.camera)),
                      _buildAddMediaBtn(Icons.link_rounded, _showEmbedDialog),
                      _buildAddMediaBtn(Icons.video_collection_rounded,
                          () => _pickAndValidateFile(FileType.video, "video"),
                          access: isPluseOrBasicPlan),
                      _buildAddMediaBtn(Icons.audio_file_rounded,
                          () => _pickAndValidateFile(FileType.audio, "audio"),
                          access: isPluseOrBasicPlan),
                      _buildAddMediaBtn(
                          Icons.file_present_rounded,
                          () => _pickAndValidateFile(FileType.custom, "file",
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
                                  ]),
                          access: isPluseOrBasicPlan),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildAddMediaBtn(IconData icon, VoidCallback onPressed,
      {bool access = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: AddMediaBtn(access: access, icon: icon, onPressed: onPressed),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    showLoading();
    final file = await controller.imagePickerRepository
        .pickImage(source: source, imageQuality: 85);
    if (file != null) {
      double fileSizeInMB = await _getFileSize(File(file.path));
      if (fileSizeInMB > 10) {
        Get.back();
        _showError('error_image_size'.tr);
      } else {
        Get.to(() => _proImageEditor(file));
      }
    }
  }

  Future<void> _pickAndValidateFile(FileType type, String textType,
      {List<String>? allowedExtensions}) async {
    showLoading();
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: type, allowedExtensions: allowedExtensions);
    if (result != null) {
      String? path = result.files.first.path;
      if (path != null) {
        File file = File(path);
        double fileSizeInMB = await _getFileSize(file);
        controller.fileSize(fileSizeInMB);
        if (fileSizeInMB > 100) {
          Get.back();
          _showError('error_file_size'.tr);
        } else {
          controller.filePath(path);
          controller.fileType(
              textType == "file" ? "file.${path.split(".").last}" : textType);
        }
      }
    }
  }

  Widget _proImageEditor(XFile path) {
    return ProImageEditor.file(
      File(path.path),
      callbacks: ProImageEditorCallbacks(
        onImageEditingComplete: (Uint8List image) async {
          showLoading();
          controller.filePath(await _saveImageToFile(image));
          controller.fileType("image");
          Get.back();
        },
        onCloseEditor: () => Get.back(),
      ),
    );
  }

  Future<String> _saveImageToFile(Uint8List image) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = "${tempDir.path}/${DateTime.now().toIso8601String()}.jpg";
    await File(tempPath).writeAsBytes(image);
    return tempPath;
  }

  Future<double> _getFileSize(File file) async {
    return ((await file.length()) / (1024 * 1024));
  }

  void _showEmbedDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Get.theme.colorScheme.tertiary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('dialog_embed_title'.tr, style: TextStyle(fontSize: 15)),
        content: CustomTextFormFeild(
          label: 'dialog_embed_label'.tr,
          textInputType: TextInputType.text,
          onChanged: (v) => controller.embedText(v),
        ),
        actions: [
          TextButton(
              onPressed: () => Get.back(), child: Text('dialog_cancel'.tr)),
          TextButton(onPressed: _addEmbed, child: Text('dialog_add'.tr)),
        ],
      ),
    );
  }

  void _addEmbed() {
    String embedText = controller.embedText.value.trim();
    if (embedText.isEmpty) return _showError('error_embed_empty'.tr);

    String? extractedUrl;
    if (embedText.contains('<iframe') && embedText.contains('src="')) {
      final splitText = embedText.split('src="');
      if (splitText.length > 1) extractedUrl = splitText[1].split('"')[0];
    } else {
      extractedUrl = embedText;
    }

    if (extractedUrl == null || !Uri.tryParse(extractedUrl)!.isAbsolute) {
      return _showError('error_embed_invalid'.tr);
    }

    controller.filePath(extractedUrl);
    controller.fileType("embedded");
    controller.embedText("");
    Get.back();
  }

  void _showError(String message) {
    Get.snackbar("Error".tr, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white);
  }
}
