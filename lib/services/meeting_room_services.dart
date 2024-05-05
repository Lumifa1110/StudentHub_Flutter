// ignore_for_file: avoid_print
import 'package:studenthub/services/api_services.dart';

class MeetingRoomService {
  static Future<Map<String, dynamic>> createRoom(dynamic body) async {
    try {
      final response = await ApiService.postRequest('/meeting-room/create-room', body);
      return response;
    } catch (e) {
      print('Error create meeting room: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> checkAvailbility(String roomCode, String roomId) async {
    try {
      final response = await ApiService.getRequest('/meeting-room/check-availability?meeting_room_code=$roomCode&meeting_room_id=$roomId');
      return response;
    } catch (e) {
      print('Error check meeting room availbility: $e');
      rethrow;
    }
  }
}