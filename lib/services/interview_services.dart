// ignore_for_file: avoid_print
import 'package:studenthub/services/api_services.dart';

class InterviewService {
  static Future<Map<String, dynamic>> getInterviewById(int interviewId) async {
    try {
      final response = await ApiService.getRequest('/api/interview/$interviewId');
      return response;
    } catch (e) {
      print('Error get interview id-$interviewId: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> createInterview(dynamic body) async {
    try {
      final response = await ApiService.postRequest('/api/interview', body);
      return response;
    } catch (e) {
      print('Error create interview: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> updateInterview(int interviewId, dynamic body) async {
    try {
      final response = await ApiService.patchRequest('/api/interview/$interviewId', body);
      return response;
    } catch (e) {
      print('Error update interview: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> deleteInterview(int interviewId) async {
    try {
      final response = await ApiService.deleteRequest('/api/interview/$interviewId', {});
      return response;
    } catch (e) {
      print('Error update interview: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getInterviewByUserId(int userId) async {
    try {
      final response = await ApiService.getRequest('/api/interview/user/$userId');
      return response;
    } catch (e) {
      print('Error get interview by userId-$userId: $e');
      rethrow;
    }
  }
}