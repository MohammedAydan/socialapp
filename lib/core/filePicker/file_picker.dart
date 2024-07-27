import 'package:file_picker/file_picker.dart';

abstract class FilePickerRepository {
  Future<FilePickerResult?> pickFile(
    bool allowMultiple,
    List<String> allowedExtensions,
  );
}

class FilePickerRepositoryImpl implements FilePickerRepository {
  @override
  Future<FilePickerResult?> pickFile(
    bool allowMultiple,
    List<String> allowedExtensions,
  ) async {
    final res = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      allowedExtensions: allowedExtensions,
    );
    return res;
  }
}
