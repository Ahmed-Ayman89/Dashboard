class AdminUser {
  final String id;
  final String fullName;
  final String phone;
  final String adminRole;
  final String status;
  final DateTime createdAt;

  AdminUser({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.adminRole,
    required this.status,
    required this.createdAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      adminRole: json['admin_role'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class CreateAdminRequest {
  final String fullName;
  final String phone;
  final String password;
  final String adminRole;

  CreateAdminRequest({
    required this.fullName,
    required this.phone,
    required this.password,
    required this.adminRole,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phone': phone,
      'password': password,
      'adminRole': adminRole,
    };
  }
}
