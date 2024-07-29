import 'package:socialapp/global/models/pay_result.dart';

class UserModel {
  String? id;
  String? userId;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? phone;
  String? imageUrl;
  int? day;
  int? month;
  int? year;
  String? accountType;
  bool? verification;
  int? followersCount;
  int? followingCount;
  int? postsCount;
  String? notificationUserId;
  DateTime? createdAt;
  bool? freePlan;
  bool? basicPlan;
  bool? plusPlan;
  UserLocation? location;
  bool? status;
  DateTime? subscriptionStartDate;
  DateTime? subscriptionEndDate;
  PaymentMethodData? subscribeData;

  UserModel({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.phone,
    this.imageUrl,
    this.day,
    this.month,
    this.year,
    this.accountType,
    this.verification,
    this.followersCount,
    this.followingCount,
    this.postsCount,
    this.notificationUserId,
    this.createdAt,
    this.freePlan = true,
    this.basicPlan = false,
    this.plusPlan = false,
    this.location,
    this.status,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.subscribeData,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["user_id"] as String?,
      userId: json["user_id"] as String?,
      firstName: json["first_name"] as String?,
      lastName: json["last_name"] as String?,
      username: json["username"] as String?,
      email: json["email"] as String?,
      phone: json["phone"] as String?,
      imageUrl: json["image_url"] as String?,
      day: json["day"] != null ? int.parse(json["day"].toString()) : null,
      month: json["month"] != null ? int.parse(json["month"].toString()) : null,
      year: json["year"] != null ? int.parse(json["year"].toString()) : null,
      accountType: json["account_type"] as String?,
      verification: json["verification"] != null
          ? json["verification"] == true ||
              json["verification"] == 'true' ||
              json["verification"] == '1'
          : null,
      followersCount: json["followers_count"] as int?,
      followingCount: json["following_count"] as int?,
      postsCount: json["posts_count"] as int?,
      notificationUserId: json["notification_user_id"],
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : null,
      freePlan: json["free_plan"] != null
          ? json["free_plan"] == true ||
              json["free_plan"] == 'true' ||
              json["free_plan"] == '1'
          : null,
      basicPlan: json["basic_plan"] != null
          ? json["basic_plan"] == true ||
              json["basic_plan"] == 'true' ||
              json["basic_plan"] == '1'
          : null,
      plusPlan: json["plus_plan"] != null
          ? json["plus_plan"] == true ||
              json["plus_plan"] == 'true' ||
              json["plus_plan"] == '1'
          : null,
      location: json["location"] != null
          ? UserLocation.fromJson(json["location"])
          : null,
      status: json["status"] != null
          ? json["status"] == true ||
              json["status"] == 'true' ||
              json["status"] == '1'
          : null,
      subscriptionStartDate: json["subscription_start_date"] != null
          ? DateTime.parse(json["subscription_start_date"])
          : null,
      subscriptionEndDate: json["subscription_end_date"] != null
          ? DateTime.parse(json["subscription_end_date"])
          : null,
      subscribeData: json["subscribe_data"] != null
          ? PaymentMethodData.fromJson(json["subscribe_data"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "first_name": firstName,
      "last_name": lastName,
      "username": username,
      "email": email,
      "phone": phone,
      "image_url": imageUrl,
      "day": day,
      "month": month,
      "year": year,
      "account_type": accountType,
      "verification": verification,
      "followers_count": followersCount,
      "following_count": followingCount,
      "posts_count": postsCount,
      "notification_user_id": notificationUserId,
      "created_at": createdAt?.toIso8601String(),
      "free_plan": freePlan,
      "basic_plan": basicPlan,
      "plus_plan": plusPlan,
      "location": location?.toJson(),
      "status": status,
      "subscription_start_date": subscriptionStartDate?.toIso8601String(),
      "subscription_end_date": subscriptionEndDate?.toIso8601String(),
      "subscribe_data": subscribeData?.toJson(),
    };
  }
}

class UserLocation {
  String? city;
  String? country;
  String? countryCode;
  double? latitude;
  double? longitude;

  UserLocation({
    this.city,
    this.country,
    this.countryCode,
    this.latitude,
    this.longitude,
  });

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      city: json["city"] as String?,
      country: json["country"] as String?,
      countryCode: json["country_code"] as String?,
      latitude: json["latitude"] as double?,
      longitude: json["longitude"] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "city": city,
      "country": country,
      "country_code": countryCode,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}
