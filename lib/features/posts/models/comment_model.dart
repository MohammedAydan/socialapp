class CommentModel {
  int? id;
  String? userId;
  String? username;
  String? email;
  String? imageUrl;
  bool? verification;
  int? postId;
  String? comment;
  String? mediaType;
  String? mediaUrl;
  int likesCount;
  DateTime? createdAt;

  CommentModel({
    this.id,
    this.userId,
    this.username,
    this.email,
    this.imageUrl,
    this.verification = false,
    this.postId,
    this.comment,
    this.mediaType,
    this.mediaUrl,
    this.likesCount = 0,
    this.createdAt,
  });

  // Factory constructor to create a CommentModel from JSON
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      userId: json['user_id'],
      username: json['users_data']['username'],
      email: json['users_data']['email'],
      imageUrl: json['users_data']['image_url'],
      verification: json['users_data']['verification'],
      postId: json['post_id'],
      comment: json['comment'],
      mediaType: json['media_type'],
      mediaUrl: json['media_url'],
      likesCount: json['likes_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Method to convert a CommentModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'post_id': postId,
      'comment': comment,
      'media_type': mediaType,
      'media_url': mediaUrl,
      'likes_count': likesCount,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
