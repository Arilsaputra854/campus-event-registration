import 'package:campus_event_registration/helper/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel {
  Future<bool> login(String email, String password) async {
    final user = await UserDatabase.getUserByEmail(email);
    if (user == null) return false;

    if (user.password == password) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_admin', user.isAdmin);
      await prefs.setInt('user_id', user.id!);

      return true;
    }

    return false;
  }
}
