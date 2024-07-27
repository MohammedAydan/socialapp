import 'package:dartz/dartz.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/features/posts/models/comment_model.dart';

abstract class CommentsRepository {
  Future<Either<Failure, List<CommentModel>>> getComments(
    String postId, {
    int? page = 1,
    int? limit = 15,
  });
  Future<Either<Failure, CommentModel>> addComment(CommentModel comment);
  Future<Either<Failure, Unit>> remove(int commentId,int postId);
}
