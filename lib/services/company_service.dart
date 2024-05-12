// ignore_for_file: avoid_print
import 'package:studenthub/services/api_services.dart';

class CompanyService {
  static Future<Map<String, dynamic>> addCompanyProfile(dynamic body) async {
    try {
      final response = await ApiService.postRequest('/api/profile/company', body);
      return response;
    } catch (e) {
      print('Error adding companny profile: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> updateCompanyProfile(String id, dynamic body) async {
    try {
      final response = await ApiService.putRequest('/api/profile/company/$id', body);
      return response;
    } catch (e) {
      print('Error updating companny profile: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getCompanyProfile(String id) async {
    try {
      final response = await ApiService.getRequest('/api/profile/company/$id');
      return response;
    } catch (e) {
      print('Error getting companny profile: $e');
      rethrow;
    }
  }
}