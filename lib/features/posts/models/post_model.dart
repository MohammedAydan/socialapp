class PostModel {
  int? postId;
  String? userId;
  int? sharingPostId;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? imageUrl;
  bool? verification;
  String? title;
  String? body;
  String? mediaType;
  String? mediaUrl;
  String? mediaName;
  double? mediaSize;
  int likesCount;
  int commentsCount;
  int sharingsCount;
  int viewsCount;
  bool public;
  String? notificationUserId;
  bool? isLikes;
  List<String>? tags;
  DateTime? createdAt;
  bool? loading;
  bool? myNewPost;

  PostModel({
    this.postId,
    this.userId,
    this.sharingPostId,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.imageUrl,
    this.verification,
    this.title,
    this.body,
    this.mediaType,
    this.mediaUrl,
    this.mediaName,
    this.mediaSize = 0.0,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharingsCount = 0,
    this.viewsCount = 0,
    this.public = true,
    this.isLikes = false,
    this.notificationUserId = "",
    this.tags,
    this.createdAt,
    this.loading = false,
    this.myNewPost = false,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['post_id'],
      userId: json['user_id'],
      sharingPostId: json['sharing_post_id'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      imageUrl: json['image_url'],
      verification: json['verification'],
      title: json['title'],
      body: json['body'],
      mediaType: json['media_type'],
      mediaUrl: json['media_url'],
      mediaName: json['media_name'],
      mediaSize: json['media_size'] != null
          ? double.tryParse(json['media_size'].toString()) ?? 0.0
          : 0.0,
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      sharingsCount: json['sharings_count'] ?? 0,
      viewsCount: json['views_count'] ?? 0,
      public: json['public'],
      isLikes: json['is_likes'] ?? false,
      notificationUserId: json['notification_user_id'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'user_id': userId,
      'sharing_post_id': sharingPostId,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'image_url': imageUrl,
      'verification': verification,
      'title': title,
      'body': body,
      'media_type': mediaType,
      'media_url': mediaUrl,
      'media_name': mediaName,
      'media_size': mediaSize,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'sharings_count': sharingsCount,
      'views_count': viewsCount,
      'public': public,
      'is_likes': isLikes,
      'notification_user_id': notificationUserId,
      'tags': tags,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
