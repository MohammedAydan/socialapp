import 'package:get/get.dart';

abstract class Failure {
  String errorMessage();
}

class OfflineFailure extends Failure {
  OfflineFailure({this.error});
  final String? error;

  @override
  String errorMessage() => error ?? 'offline'.tr;
}

class NotFoundFailure extends Failure {
  NotFoundFailure({this.error});
  final String? error;

  @override
  String errorMessage() => error ?? 'not_found'.tr;
}

class ServerFailure extends Failure {
  ServerFailure({this.error});
  final String? error;

  @override
  String errorMessage() => error ?? 'server_error'.tr;
}

class EmptyCacheFailure extends Failure {
  EmptyCacheFailure({this.error});
  final String? error;

  @override
  String errorMessage() => error ?? 'empty_cache'.tr;
}

String getMessageFromFailure(Failure failure) {
  switch (failure.runtimeType) {
    case OfflineFailure:
      return (failure as OfflineFailure).errorMessage();
    case NotFoundFailure:
      return (failure as NotFoundFailure).errorMessage();
    case ServerFailure:
      return (failure as ServerFailure).errorMessage();
    case EmptyCacheFailure:
      return (failure as EmptyCacheFailure).errorMessage();
    default:
      return 'unknown_error'.tr;
  }
}
