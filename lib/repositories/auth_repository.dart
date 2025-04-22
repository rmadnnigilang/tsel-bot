import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthRepository {
  final baseUrl = 'http://128.199.129.151:5010';

  Future<User> login(String msisdn) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'msisdn': msisdn}),
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200 && json['error'] == false) {
      return User.fromJson(json['data']);
    } else {
      throw Exception(json['message'] ?? 'Login failed');
    }
  }
}
