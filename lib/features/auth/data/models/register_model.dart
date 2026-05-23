class RegisterModel {
  final bool status;
  final String message;
  final RegisterData? data;

  RegisterModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? RegisterData.fromJson(json['data']) : null,
    );
  }
}

class RegisterData {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String token;

  RegisterData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.token,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      token: json['token'] ?? '',
    );
  }
}
