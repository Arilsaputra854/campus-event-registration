class UserModel {
  final int? id;
  final String name;
  final String email;
  final String nim;
  final String phone;
  final String password;
  final bool isAdmin;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.nim,
    required this.phone,
    required this.password,
    this.isAdmin = false,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      nim: map['nim'],
      phone: map['phone'],
      password: map['password'],
      isAdmin: map['is_admin'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'nim': nim,
      'phone': phone,
      'password': password,
      'is_admin': isAdmin ? 1 : 0,
    };
  }
}
