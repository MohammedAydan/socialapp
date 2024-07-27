class SharingModel {
  final int id;
  final DateTime createdAt;
  final int? postId;
  final String? userId;

  SharingModel({
    required this.id,
    required this.createdAt,
    this.postId,
    this.userId,
  });

  // Factory constructor to create a SharingModel from JSON
  factory SharingModel.fromJson(Map<String, dynamic> json) {
    return SharingModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      postId: json['post_id'],
      userId: json['user_id'],
    );
  }

  // Method to convert a SharingModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'post_id': postId,
      'user_id': userId,
    };
  }
}
