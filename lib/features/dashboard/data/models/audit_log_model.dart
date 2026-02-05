class AuditLogModel {
  final String id;
  final String admin;
  final String adminPhone;
  final String action;
  final String targetId;
  final Map<String, dynamic>? details;
  final String? ipAddress;
  final DateTime createdAt;

  AuditLogModel({
    required this.id,
    required this.admin,
    required this.adminPhone,
    required this.action,
    required this.targetId,
    this.details,
    this.ipAddress,
    required this.createdAt,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) {
    return AuditLogModel(
      id: json['id'],
      admin: json['admin'],
      adminPhone: json['admin_phone'],
      action: json['action'],
      targetId: json['target_id'],
      details: json['details'],
      ipAddress: json['ip_address'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin': admin,
      'admin_phone': adminPhone,
      'action': action,
      'target_id': targetId,
      'details': details,
      'ip_address': ipAddress,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
