class RedemptionModel {
  final String id;
  final String userPhone;
  final String userRole;
  final double amount;
  final String method;
  final String details;
  final String status;
  final DateTime createdAt;

  RedemptionModel({
    required this.id,
    required this.userPhone,
    required this.userRole,
    required this.amount,
    required this.method,
    required this.details,
    required this.status,
    required this.createdAt,
  });

  factory RedemptionModel.fromJson(Map<String, dynamic> json) {
    return RedemptionModel(
      id: json['id'] ?? '',
      userPhone: json['user_phone'] ?? '',
      userRole: json['user_role'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      method: json['method'] ?? '',
      details: json['details'] ?? '',
      status: json['status'] ?? 'PENDING',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
