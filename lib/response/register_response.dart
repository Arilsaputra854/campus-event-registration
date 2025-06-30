class RegisterResponse {
  final bool success;
  final String? message;
  final dynamic data;

  RegisterResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory RegisterResponse.success(dynamic data) {
    return RegisterResponse(success: true, data: data);
  }

  factory RegisterResponse.failure(String message) {
    return RegisterResponse(success: false, message: message);
  }
}
