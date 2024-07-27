import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/core/network/network_info.dart';
import 'package:socialapp/features/settings/services/repositories/settings_repository.dart';
import 'package:socialapp/main.dart';

const String LANG_KEY = "SOCIAL_LANG";
const String MODE_KEY = "SOCIAL_MODE";

class SettingsRepositoryImpl implements SettingsRepository {
  final NetworkInfo networkInfo;
  final GetStorage storage;

  SettingsRepositoryImpl(this.networkInfo, this.storage);

  @override
  Future<Either<Failure, Unit>> changeAccountType(String type) async {
    if ((await networkInfo.isConnected) == true) {
      try {
        await supabase.from("users_data").update({
          "account_type": type,
        }).eq("user_id", supabase.auth.currentUser!.id);
        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Unit> changeLang(String lang) async {
    Get.updateLocale(Locale(lang));
    await storage.write(LANG_KEY, lang);
    return unit;
  }

  @override
  Future<Unit> changeMode(bool dark) async {
    if (dark) {
      Get.changeThemeMode(ThemeMode.dark);
      await storage.write(MODE_KEY, dark);
    } else {
      Get.changeThemeMode(ThemeMode.light);
      await storage.write(MODE_KEY, dark);
    }
    return unit;
  }

  @override
  String? getLang() {
    return storage.read(LANG_KEY);
  }

  @override
  bool? isDarkMode() {
    return storage.read(MODE_KEY);
  }
}
