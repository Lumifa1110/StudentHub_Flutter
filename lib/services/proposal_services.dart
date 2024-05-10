// ignore_for_file: avoid_print
import 'package:studenthub/services/api_services.dart';

class ProposalService {
  static Future<Map<String, dynamic>> getProjectByCompanyId(int proposalId) async {
    try {
      final response = await ApiService.getRequest('/api/proposal/$proposalId');
      return response;
    } catch (e) {
      print('Error get proposal by ID: $e');
      rethrow;
    }
  }
}
