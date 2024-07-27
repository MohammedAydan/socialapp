class UserRegisterModel {
  final String fName;
  final String lName;
  final String username;
  final String email;
  final int day;
  final int month;
  final int year;
  final String password;
  final String rePassword;

  UserRegisterModel({
    required this.fName,
    required this.lName,
    required this.username,
    required this.email,
    required this.day,
    required this.month,
    required this.year,
    required this.password,
    required this.rePassword,
  });

  factory UserRegisterModel.fromJson(Map<String, dynamic> json) {
    return UserRegisterModel(
      fName: json["fName"],
      lName: json["lName"],
      username: json["username"],
      email: json["email"],
      day: int.parse(json["day"]),
      month: int.parse(json["month"]),
      year: int.parse(json["year"]),
      password: json["password"],
      rePassword: json["rePassword"],
    );
  }

  Map<String, String> toMap() {
    return {
      'first_name': fName,
      'last_name': lName,
      'username': username,
      'email': email,
      'day': day.toString(),
      'month': month.toString(),
      'year': year.toString(),
    };
  }
}
