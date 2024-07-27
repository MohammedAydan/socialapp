class FollowerModel {
  final int id;
  final String? followingUserId;
  final String? followerUserId;
  final bool status;
  final DateTime createdAt;

  FollowerModel({
    required this.id,
    this.followingUserId,
    this.followerUserId,
    this.status = false,
    required this.createdAt,
  });

  // Factory constructor to create a FollowerModel from JSON
  factory FollowerModel.fromJson(Map<String, dynamic> json) {
    return FollowerModel(
      id: json['id'],
      followingUserId: json['following_user_id'],
      followerUserId: json['follower_user_id'],
      status: json['status'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Method to convert a FollowerModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'following_user_id': followingUserId,
      'follower_user_id': followerUserId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
