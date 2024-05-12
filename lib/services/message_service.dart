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

  static Future<Map<String, dynamic>> getMessageByProjectIdAndUserId(int projectId, int userId) async {
    try {
      final response = await ApiService.getRequest('/api/message/$projectId/user/$userId');
      return response;
    } catch (e) {
      print('Error get message by projectId and userId: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> sendMessage(dynamic body) async {
    try {
      final response = await ApiService.postRequest('/api/message/sendMessage', body);
      return response;
    } catch (e) {
      print('Error send message: $e');
      rethrow;
    }
  }
}