class NotificationModel {
  int? id;
  String? myId;
  String? userId;
  int? postId;
  Map<String, String>? title;
  Map<String, String>? body;
  String? type;
  bool readed;
  DateTime? createdAt;

  NotificationModel({
    this.id,
    this.userId,
    this.postId,
    this.title,
    this.body,
    this.type,
    this.readed = false,
    this.createdAt,
    this.myId,
  });

  // Factory method to create a Notification from a map (e.g., JSON)
  factory NotificationModel.fromJson(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      myId: map['my_id'],
      userId: map['user_id'],
      postId: map['post_id'],
      title:
          (map['title'] is Map) ? Map<String, String>.from(map['title']) : null,
      body: (map['body'] is Map) ? Map<String, String>.from(map['body']) : null,
      type: map['type'],
      readed: map['readed'] ?? false,
      createdAt: DateTime.tryParse(map['created_at'] ?? ''),
    );
  }

  // Method to convert a Notification to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'post_id': postId,
      'title': title,
      'body': body,
      'type': type,
      'readed': readed,
      'created_at': createdAt?.toIso8601String(),
      'my_id': myId,
    };
  }
}
