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
}