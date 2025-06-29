import 'dart:convert';
import 'package:campus_event_registration/model/user.dart';
import 'package:http/http.dart' as http;

class RegisterViewModel {
  final String _baseUrl = 'https://api2.isc-webdev.my.id/api/register';

  Future<Map<String, dynamic>> register(UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      final data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Registrasi gagal'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan. Coba lagi.'};
    }
  }
}
