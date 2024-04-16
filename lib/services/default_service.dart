// ignore_for_file: avoid_print
import 'package:studenthub/services/api_services.dart';

class DefaultService {
  static Future<Map<String, dynamic>> getAllTechstack() async {
    try {
      final response = await ApiService.getRequest('/api/techstack/getAllTechStack');
      return response;
    } catch (e) {
      print('Error get all techstack: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getAllSkillset() async {
    try {
      final response = await ApiService.getRequest('/api/skillset/getAllSkillSet');
      return response;
    } catch (e) {
      print('Error get all skillset: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> updateStudentExperience(String id, dynamic body) async {
    try {
      final response = await ApiService.putRequest('/api/experience/updateByStudentId/$id', body);
      return response;
    } catch (e) {
      print('Error update student experience: $e');
      rethrow;
    }
  }
}