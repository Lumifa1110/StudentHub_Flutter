// ignore_for_file: avoid_print
import 'package:studenthub/services/api_services.dart';

class MessageService {
  static Future<Map<String, dynamic>> getAllMessage() async {
    try {
      final response = await ApiService.getRequest('/api/message');
      return response;
    } catch (e) {
      print('Error get all message: $e');
      rethrow;
    }
  }
}