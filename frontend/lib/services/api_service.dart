import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();

  static const String baseUrl = 'http://10.0.2.2:3000';
  // static const String baseUrl = 'http://localhost:3000';

  String? token;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  Future<http.Response> get(String endpoint) {
    return http.get(Uri.parse(baseUrl + endpoint), headers: _headers);
  }

  Future<http.Response> post(String endpoint, Object body) {
    return http.post(
      Uri.parse(baseUrl + endpoint),
      headers: _headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> put(String endpoint, Object body) {
    return http.put(
      Uri.parse(baseUrl + endpoint),
      headers: _headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(String endpoint) {
    return http.delete(Uri.parse(baseUrl + endpoint), headers: _headers);
  }
}
