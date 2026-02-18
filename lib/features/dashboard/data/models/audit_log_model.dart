class AuditLogModel {
  final String id;
  final String admin;
  final String adminPhone;
  final String action;
  final String targetId;
  final Map<String, dynamic>? details;
  final String? ipAddress;
  final DateTime createdAt;

  final String summary;

  AuditLogModel({
    required this.id,
    required this.admin,
    required this.adminPhone,
    required this.action,
    required this.targetId,
    this.details,
    this.ipAddress,
    required this.createdAt,
    required this.summary,
  });

  factory AuditLogModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return AuditLogModel(
        id: '',
        admin: 'Unknown',
        adminPhone: '',
        action: '',
        targetId: '',
        createdAt: DateTime.now(),
        summary: 'Invalid log data',
      );
    }
    return AuditLogModel(
      id: json['id']?.toString() ?? '',
      admin: json['admin']?.toString() ?? 'Unknown',
      adminPhone: json['admin_phone']?.toString() ?? '',
      action: json['action']?.toString() ?? '',
      targetId: json['target_id']?.toString() ?? '',
      details:
          (json['details'] != null && json['details'] is Map<String, dynamic>)
              ? json['details'] as Map<String, dynamic>
              : null,
      ipAddress: json['ip_address']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      summary: json['summary']?.toString() ?? '',
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
      'summary': summary,
    };
  }
}
