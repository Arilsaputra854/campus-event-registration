class UserModel {
  final String name;
  final String email;
  final String nim;
  final String phone;
  final String password;

  UserModel({
    required this.name,
    required this.email,
    required this.nim,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'nim': nim,
      'phone': phone,
      'password': password,
    };
  }
}
