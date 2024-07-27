import 'package:dartz/dartz.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/core/network/network_info.dart';
import 'package:socialapp/features/posts/models/comment_model.dart';
import 'package:socialapp/features/posts/services/repositories/comments_repository.dart';
import 'package:socialapp/main.dart';

class CommentsRepositoryImpl implements CommentsRepository {
  final NetworkInfo networkInfo;

  CommentsRepositoryImpl(this.networkInfo);

  @override
  Future<Either<Failure, CommentModel>> addComment(CommentModel comment) async {
    if (await networkInfo.isConnected) {
      final userId = supabase.auth.currentUser?.id;
      final res = await supabase.from("comments").insert({
        'user_id': userId,
        'post_id': comment.postId,
        'comment': comment.comment,
        'media_type': comment.mediaType,
        'media_url': comment.mediaUrl,
      });

      await supabase.rpc("increment_comments_count", params: {
        "p_post_id": comment.postId,
      });

      comment.userId != userId;

      return Right(comment);
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<CommentModel>>> getComments(String postId,
      {int? page = 1, int? limit = 15}) async {
    if (await networkInfo.isConnected) {
      try {
        final int offset = (page! - 1) * limit!;
        final res = await supabase
            .from("comments")
            .select(
              '*, users_data(username,user_id,email,image_url,verification)',
            )
            .eq("post_id", postId)
            .order("created_at", ascending: false)
            .order("likes_count")
            .range(offset, offset + limit - 1);

        final finalComment = res.map((c) => CommentModel.fromJson(c)).toList();

        return Right(finalComment);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> remove(int commentId, int postId) async {
    if (await networkInfo.isConnected) {
      await supabase.from("comments").delete().eq("id", commentId);
      await supabase.rpc("decrement_comments_count", params: {
        "p_post_id": postId,
      });
      return const Right(unit);
    } else {
      return Left(OfflineFailure());
    }
  }
}
