import 'package:dartz/dartz.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/features/notifications/models/notification_model.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, Unit>> sendNotification(
    NotificationModel notification,
  );
  Future<Either<Failure, List<NotificationModel>>> getMyNotifications({
    int? page = 1,
    int? limit = 10,
  });
  Future<Either<Failure, Unit>> readedNotification(String id);
  Future<Either<Failure, Unit>> readedAllNotification();
}
