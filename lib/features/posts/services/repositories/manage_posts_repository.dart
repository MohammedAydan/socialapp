import 'package:dartz/dartz.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/features/auth/models/user_model.dart';
import 'package:socialapp/features/posts/models/post_model.dart';

abstract class ManagePostsRepository {
  Future<Either<Failure, List<PostModel>>> getPosts({
    int page = 1,
    int limit = 10,
  });
  Future<Either<Failure, PostModel>> getPost(int id);
  Future<Either<Failure, List<PostModel>>> getPostsByUserId(
    String id, {
    bool isPublic = true,
    bool all = false,
    int page = 1,
    int limit = 10,
  });
  Future<Either<Failure, PostModel>> addPost(PostModel post);
  Future<Either<Failure, PostModel>> updatePost(PostModel post);
  Future<Either<Failure, Unit>> deletePost(PostModel post);
  Future<Either<Failure, List<PostModel>>> getPostsByMediaType({
    int page = 1,
    int limit = 10,
    String? mediaType = "video",
  });
  Future<Either<Failure, List<UserModel>>> getLikes(
    int postId, {
    int page = 1,
    int limit = 20,
  });
  Future<Either<Failure, List<UserModel>>> getShareings(
    int postId, {
    int page = 1,
    int limit = 20,
  });
}
