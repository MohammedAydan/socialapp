import 'package:dartz/dartz.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/core/network/network_info.dart';
import 'package:socialapp/features/posts/services/repositories/post_repository.dart';
import 'package:socialapp/main.dart';

class PostRepositoryImpl implements PostRepository {
  final NetworkInfo networkInfo;

  PostRepositoryImpl(this.networkInfo);

  @override
  Future<Either<Failure, Unit>> addLike(String postId) async {
    if ((await networkInfo.isConnected) == true) {
      await supabase.rpc("insert_like", params: {
        "p_user_id": supabase.auth.currentUser?.id,
        "p_post_id": postId,
      });

      return const Right(unit);
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> removeLike(String postId) async {
    if ((await networkInfo.isConnected) == true) {
      await supabase.rpc("remove_like", params: {
        "p_user_id": supabase.auth.currentUser?.id,
        "p_post_id": postId,
      });

      return const Right(unit);
    } else {
      return Left(OfflineFailure());
    }
  }
}
