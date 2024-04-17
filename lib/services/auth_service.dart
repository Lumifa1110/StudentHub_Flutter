// ignore_for_file: avoid_print
import 'package:studenthub/services/api_services.dart';

class AuthService {
  static Future<Map<String, dynamic>> signIn(dynamic body) async {
    try {
      final response = await ApiService.postRequest('/api/auth/sign-in', body);
      return response;
    } catch (e) {
      print('Error signing in: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> signUp(dynamic body) async {
    try {
      final response = await ApiService.postRequest('/api/auth/sign-up', body);
      return response;
    } catch (e) {
      print('Error signing up: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> logOut() async {
    try {
      final response = await ApiService.postRequest('/api/auth/logout', {});
      return response;
    } catch (e) {
      print('Error signing up: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final response = await ApiService.getRequest('/api/auth/me');
      return response;
    } catch (e) {
      print('Error get user info: $e');
      rethrow;
    }
  }
}