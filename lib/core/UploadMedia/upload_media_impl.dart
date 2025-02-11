import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socialapp/core/UploadMedia/upload_media.dart';

const String cloudBaseUrl = "https://api.cloudinary.com/v1_1/";

class UploadMediaImpl implements UploadMedia {
  final Dio dio;
  String url = "$cloudBaseUrl${dotenv.env["CLOUDINARY_CLOUD_NAME"]}/upload";
  String uploadPreset = "my_social_app";

  UploadMediaImpl({required this.dio});

  @override
  Future<String> uploadMedia(String filePath) async {
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath),
        "upload_preset": uploadPreset,
      });

      Response response = await dio.post(url, data: formData);

      return response.data["url"];
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteImageFromCloudinary(String resourceUrl) async {
    try {
      // implementation
    } catch (e) {
      print('Error deleting image: $e');
      throw Exception('Error deleting image: $e');
    }
  }
}
