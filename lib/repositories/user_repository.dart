import 'dart:convert';

import 'package:http/http.dart' as http;

class UserRepository {
  final baseUrl = 'https://llmcore.aspal.in/llm-demo-flask/v-1/user/profile';

  Future<Map<String, dynamic>> fetchUserProfile(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final json = jsonDecode(response.body);
    if (response.statusCode == 200 && json['error'] == false) {
      return json['data'];
    } else {
      throw Exception(json['message'] ?? 'Gagal memuat profil');
    }
  }
}
