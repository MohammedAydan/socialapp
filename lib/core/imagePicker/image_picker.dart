import 'package:image_picker/image_picker.dart';

abstract class ImagePickerRepository {
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  });
}

class ImagePickerRepositoryImpl implements ImagePickerRepository {
  final ImagePicker imagePicker;

  const ImagePickerRepositoryImpl(this.imagePicker);

  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    return await imagePicker.pickImage(source: source);
  }
}
