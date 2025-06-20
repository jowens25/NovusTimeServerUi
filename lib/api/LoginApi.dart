import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginApi extends ChangeNotifier {
  final String baseUrl;
  bool _loggedIn = false;
  String? _token;

  bool get isLoggedIn => _loggedIn;
  String? get token => _token;

  LoginApi({required this.baseUrl});

  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'Username': username, 'Password': password}),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      _loggedIn = true;
      _token = body['token']; // adjust to your API's key
      notifyListeners();
      return body;
    } else if (response.statusCode == 400) {
      throw Exception('Invalid request: ${response.body}');
    } else if (response.statusCode == 401) {
      throw Exception('Invalid username or password');
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  void logout() {
    _loggedIn = false;
    _token = null;
    notifyListeners();
  }
}
