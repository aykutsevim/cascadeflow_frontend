import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WebService {
  static const String _baseUrl = 'https://localhost:3001/api/';
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    var uri = Uri.parse(_baseUrl + endpoint);
    String? token = _prefs?.getString('jwt_token');
    return http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: body != null ? jsonEncode(body) : null,
    );
  }

  static Future<http.Response> get(String endpoint) async {
    var uri = Uri.parse(_baseUrl + endpoint);
    String? token = _prefs?.getString('jwt_token');
    return http.get(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  static Future<void> storeToken(String token) async {
    await _prefs?.setString('jwt_token', token);
  }

  static Future<void> clearToken() async {
    await _prefs?.remove('jwt_token');
  }


}