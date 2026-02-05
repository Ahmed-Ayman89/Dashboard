class OwnerModel {
  final String id;
  final String fullName;
  final String phone;
  final String status;
  final bool isVerified;
  final DateTime createdAt;

  OwnerModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.status,
    required this.isVerified,
    required this.createdAt,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      status: json['status'] ?? 'PENDING',
      isVerified: json['is_verified'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
