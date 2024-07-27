import 'package:dartz/dartz.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/core/network/network_info.dart';
import 'package:socialapp/features/notifications/models/notification_model.dart';
import 'package:socialapp/features/notifications/services/repositories/notifications_repository.dart';
import 'package:socialapp/main.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NetworkInfo networkInfo;
  final GetStorage storage;

  NotificationsRepositoryImpl(this.networkInfo, this.storage);

  @override
  Future<Either<Failure, List<NotificationModel>>> getMyNotifications({
    int? page = 1,
    int? limit = 20,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final userId = supabase.auth.currentUser?.id;
        if (userId == null) {
          return Left(ServerFailure());
        }

        final int offset = (page! - 1) * limit!;
        final res = await supabase
            .from("notifications")
            .select()
            .eq("user_id", userId)
            .order("created_at", ascending: false)
            .range(offset, offset + limit - 1);

        await storage.write("$page-${limit}_NOTIFICATIONS_$userId", res);

        List<NotificationModel> ns = (res as List).map((n) {
          return NotificationModel.fromJson(n);
        }).toList();

        return Right(ns);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        return Left(ServerFailure());
      }

      final localData =
          await storage.read("$page-${limit}_NOTIFICATIONS_$userId");
      if (localData != null) {
        List localNotifications = localData;
        List<NotificationModel> ns = localNotifications.map((n) {
          return NotificationModel.fromJson(n);
        }).toList();

        return Right(ns);
      }
      return Left(NotFoundFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> sendNotification(
      NotificationModel notification) async {
    if (await networkInfo.isConnected) {
      try {
        await supabase.from("notifications").insert({
          'my_id': supabase.auth.currentUser?.id,
          'user_id': notification.userId,
          'post_id': notification.postId,
          'title': notification.title,
          'body': notification.body,
          'type': notification.type,
        });
        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> readedNotification(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await supabase.from("notifications").update({
          'readed': true,
        }).eq("id", id);
        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> readedAllNotification() async {
    if (await networkInfo.isConnected) {
      try {
        await supabase
            .from("notifications")
            .update({
              'readed': true,
            })
            .eq("user_id", supabase.auth.currentUser?.id ?? "")
            .eq("readed", false);
        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
