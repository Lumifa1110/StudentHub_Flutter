// ignore_for_file: avoid_print
import 'package:studenthub/services/api_services.dart';

class AuthService {
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