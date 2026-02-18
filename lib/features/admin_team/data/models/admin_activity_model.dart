import 'admin_model.dart';

class AdminActivity {
  final String id;
  final String action;
  final String targetId;
  final Map<String, dynamic>? details;
  final String? ipAddress;
  final DateTime createdAt;

  AdminActivity({
    required this.id,
    required this.action,
    required this.targetId,
    this.details,
    this.ipAddress,
    required this.createdAt,
  });

  factory AdminActivity.fromJson(Map<String, dynamic> json) {
    return AdminActivity(
      id: json['id'] ?? '',
      action: json['action'] ?? '',
      targetId: json['target_id'] ?? '',
      details: json['details'],
      ipAddress: json['ip_address'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class AdminActivitiesResponse {
  final AdminUser admin;
  final List<AdminActivity> activities;
  final int total;
  final int page;
  final int limit;

  AdminActivitiesResponse({
    required this.admin,
    required this.activities,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory AdminActivitiesResponse.fromJson(Map<String, dynamic> json) {
    return AdminActivitiesResponse(
      admin: AdminUser.fromJson(json['admin'] ?? {}),
      activities: (json['activities'] as List?)
              ?.map((e) => AdminActivity.fromJson(e))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 20,
    );
  }
}
