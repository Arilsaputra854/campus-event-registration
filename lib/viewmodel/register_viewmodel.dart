
import 'package:campus_event_registration/helper/database_helper.dart';
import 'package:campus_event_registration/model/user.dart';

class RegisterViewModel {

    Future<bool> register(UserModel user) async {
    try {
      await UserDatabase.insertUser(user);
      return true;
    } catch (e) {
      return false;
    }
  }

}
