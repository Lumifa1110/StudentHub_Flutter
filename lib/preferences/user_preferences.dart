import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/enums/user_role.dart';

class UserPreferences {
  static const String _userRoleKey = 'user_role';

  static Future<void> setUserRole(UserRole role) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userRoleKey, role.index);
  }

  static Future<UserRole?> getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? roleIndex = prefs.getInt(_userRoleKey);
    if (roleIndex != null && UserRole.values.length > roleIndex) {
      return UserRole.values[roleIndex];
    }
    return null;
  }
}