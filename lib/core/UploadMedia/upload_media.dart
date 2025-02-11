
abstract class UploadMedia {
  Future<String> uploadMedia(String filePath);
  Future<void> deleteImageFromCloudinary(String resourceUrl);
}