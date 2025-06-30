class LoginResponse {
  final bool success;
  final String? message;
  final dynamic data;

  LoginResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory LoginResponse.success(dynamic data) {
    return LoginResponse(success: true, data: data);
  }

  factory LoginResponse.failure(String message) {
    return LoginResponse(success: false, message: message);
  }
}
