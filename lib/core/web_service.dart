import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';


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

  static String formatCode(int number) {
    if (number < 0 || number >= 67600) {
      throw ArgumentError("Number must be between 0 and 67599.");
    }

    int alphaPart = number ~/ 100; // Get the part for the alphabetic code.
    int numericPart = number % 100; // Get the numeric part.

    // Convert the number to a two-letter code (base-26).
    String firstLetter = String.fromCharCode((alphaPart ~/ 26) + 65); // 65 is the ASCII value for 'A'.
    String secondLetter = String.fromCharCode((alphaPart % 26) + 65);

    // Format the numeric part to ensure it is two digits.
    String numericCode = numericPart.toString().padLeft(2, '0');

    return firstLetter + secondLetter + numericCode;
  }

  static String generateGuid() {
    // Create uuid object
    var uuid = const Uuid();

    // Generate a v5 (namespace-name-sha1-based) id
    return uuid.v5(Uuid.NAMESPACE_URL, _baseUrl).toString(); 
  }
}