class User {
  final String id;
  final String msisdn;
  final String name;
  final String token;
  final int userId;
  final String msisdnType;

  User({
    required this.id,
    required this.msisdn,
    required this.name,
    required this.token,
    required this.userId,
    required this.msisdnType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      msisdn: json['msisdn'],
      name: json['name'],
      token: json['token'],
      userId: json['user_id'],
      msisdnType: json['msisdn_type'],
    );
  }
}
