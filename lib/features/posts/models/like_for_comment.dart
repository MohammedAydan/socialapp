class LikeForCommentModel {
  final int id;
  final DateTime createdAt;
  final String? userId;
  final int? postId;
  final int? commentId;

  LikeForCommentModel({
    required this.id,
    required this.createdAt,
    this.userId,
    this.postId,
    this.commentId,
  });

  // Factory constructor to create a LikeForCommentModel from JSON
  factory LikeForCommentModel.fromJson(Map<String, dynamic> json) {
    return LikeForCommentModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      userId: json['user_id'],
      postId: json['post_id'],
      commentId: json['comment_id'],
    );
  }

  // Method to convert a LikeForCommentModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
      'post_id': postId,
      'comment_id': commentId,
    };
  }
}
