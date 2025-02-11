import 'package:get/get.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/features/auth/controllers/auth_controller.dart';
import 'package:socialapp/features/settings/services/repositories/settings_repository.dart';
import 'package:socialapp/widgets/loading.dart';

class SettingsController extends GetxController {
  final SettingsRepository settingsRepository;
  final AuthController authController;
  RxString accountType = "".obs;
  RxString error = "".obs;

  SettingsController(this.settingsRepository, this.authController) {
    // Update accountType when user changes
    accountType(authController.user.value?.accountType ?? "");
    ever(authController.user, (user) {
      accountType(user?.accountType ?? "");
    });
  }

  Future<void> changeLang(String lang) async {
    Get.back();
    await settingsRepository.changeLang(lang);
  }

  Future<void> changeMode(bool mode) async {
    Get.back();
    await settingsRepository.changeMode(mode);
  }

  Future<void> changeAccountType(String type) async {
    try {
      error("");
      showLoading();
      final res = await settingsRepository.changeAccountType(type);
      res.fold((l) {
        error(getMessageFromFailure(l));
      }, (r) {
        accountType(type);
        authController.user.value?.accountType = type;
        authController.update();
      });
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      update();
      Get.back();
    }
  }

  String? getLang() {
    return settingsRepository.getLang();
  }

  bool? isDarkMode() {
    return settingsRepository.isDarkMode();
  }
  
}
