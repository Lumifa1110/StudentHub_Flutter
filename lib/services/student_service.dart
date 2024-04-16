// ignore_for_file: avoid_print
import 'package:studenthub/services/api_services.dart';

class StudentService {
  static Future<Map<String, dynamic>> addStudentProfile(dynamic body) async {
    try {
      final response = await ApiService.postRequest('/api/profile/student', body);
      return response;
    } catch (e) {
      print('Error update student profile: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> updateStudentProfile(String id, dynamic body) async {
    try {
      final response = await ApiService.putRequest('/api/profile/student/$id', body);
      return response;
    } catch (e) {
      print('Error update student profile: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> addStudentLanguage(String id, dynamic body) async {
    try {
      final response = await ApiService.putRequest('/api/language/updateByStudentId/$id', body);
      return response;
    } catch (e) {
      print('Error add student language: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> addStudentEducation(String id, dynamic body) async {
    try {
      final response = await ApiService.putRequest('/api/education/updateByStudentId/$id', body);
      return response;
    } catch (e) {
      print('Error add student education: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> addStudentExperience(String id, dynamic body) async {
    try {
      final response = await ApiService.putRequest('/api/experience/updateByStudentId/$id', body);
      return response;
    } catch (e) {
      print('Error add student experience: $e');
      rethrow;
    }
  }
}