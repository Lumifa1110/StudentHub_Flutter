import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // static const String baseUrl = 'http://34.16.137.128';
  static const String baseUrl = 'https://api.studenthub.dev';

  static Future<String?> getAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, String>> getHeaders() async {
    final String? authToken = await getAuthToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
  }

  static Future<Map<String, dynamic>> getRequest(String endpoint) async {
    final Map<String, String> headers = await getHeaders();
    final response = await http.get(Uri.parse(baseUrl + endpoint), headers: headers);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<Map<String, dynamic>> postRequest(String endpoint, dynamic body) async {
    final Map<String, String> headers = await getHeaders();
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }
  
  static Future<Map<String, dynamic>> putRequest(String endpoint, dynamic body) async {
    final Map<String, String> headers = await getHeaders();
    final response = await http.put(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }

  static Future<Map<String, dynamic>> patchRequest(String endpoint, dynamic body) async {
    final Map<String, String> headers = await getHeaders();
    final response = await http.patch(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }

  static Future<Map<String, dynamic>> deleteRequest(String endpoint, dynamic body) async {
    final Map<String, String> headers = await getHeaders();
    final response = await http.delete(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }

  // Add methods for other HTTP requests as needed (PUT, DELETE, etc.)
}
