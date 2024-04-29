// ignore_for_file: avoid_print
import 'package:studenthub/services/api_services.dart';

class ProjectService {
  static Future<Map<String, dynamic>> getProjectByCompanyId(dynamic companyId) async {
    try {
      final response = await ApiService.getRequest('/api/project/company/$companyId');
      return response;
    } catch (e) {
      print('Error get project by companny ID: $e');
      rethrow;
    }
  }
}
