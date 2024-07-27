import 'package:dartz/dartz.dart';
import 'package:socialapp/core/error/failure.dart';

abstract class SettingsRepository {
  // types: ar | en
  Future<Unit> changeLang(String lang);
  // types: true = dark | false = light
  Future<Unit> changeMode(bool dark);
  // types: public | private
  Future<Either<Failure, Unit>> changeAccountType(String type);

  bool? isDarkMode();
  String? getLang();
}
