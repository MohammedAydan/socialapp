class LikeModel {
  final int id;
  final String? userId;
  final int? postId;
  final DateTime createdAt;

  LikeModel({
    required this.id,
    this.userId,
    this.postId,
    required this.createdAt,
  });

  // Factory constructor to create a LikeModel from JSON
  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
      id: json['id'],
      userId: json['user_id'],
      postId: json['post_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Method to convert a LikeModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'post_id': postId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
