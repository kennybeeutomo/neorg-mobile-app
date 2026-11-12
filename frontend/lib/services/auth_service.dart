import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class AuthService {
  final api = ApiService.instance;

  static const _tokenKey = 'token';

  Future<bool> login(String email, String password) async {
    final response = await api.post('/auth/login', {
      'email': email,
      'password': password,
    });

    if (response.statusCode != 200) {
      return false;
    }

    final json = jsonDecode(response.body);

    final token = json['token'];

    api.token = token;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_tokenKey, token);

    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    final response = await api.post('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
    });

    return response.statusCode == 200;
  }

  Future<bool> loadToken() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString(_tokenKey);

    if (token == null) {
      return false;
    }

    api.token = token;

    return true;
  }

  Future<void> logout() async {
    api.token = null;

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_tokenKey);
  }

  Future<bool> isLoggedIn() async {
    return loadToken();
  }
}
