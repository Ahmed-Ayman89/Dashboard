import 'package:dashboard_grow/features/dues/domain/entities/due.dart';

class DueModel extends Due {
  const DueModel({
    required super.id,
    required super.kioskId,
    required super.amount,
    required super.isPaid,
    super.collectedBy,
    super.lastCollectedAt,
    required super.createdAt,
    required super.updatedAt,
    required super.kioskName,
    required super.ownerName,
  });

  factory DueModel.fromJson(Map<String, dynamic> json) {
    return DueModel(
      id: json['id']?.toString() ?? '',
      kioskId: json['kiosk_id']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '0',
      isPaid: json['is_paid'] ?? false,
      collectedBy: json['collected_by']?.toString(),
      lastCollectedAt: json['last_collected_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      kioskName: json['kiosk']?['name']?.toString() ?? 'Unknown',
      ownerName: json['kiosk']?['owner']?['full_name']?.toString() ?? 'Unknown',
    );
  }
}

class DueResponseModel {
  final bool success;
  final String message;
  final List<DueModel> dueList;
  final int total;
  final int page;
  final int limit;

  DueResponseModel({
    required this.success,
    required this.message,
    required this.dueList,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory DueResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return DueResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      total: data['total'] ?? 0,
      page: data['page'] ?? 1,
      limit: data['limit'] ?? 10,
      dueList: (data['dues'] != null ? (data['dues'] as List) : [])
          .map((e) => DueModel.fromJson(e))
          .toList(),
    );
  }
}
