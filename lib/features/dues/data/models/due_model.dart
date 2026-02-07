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

  DueResponseModel({
    required this.success,
    required this.message,
    required this.dueList,
  });

  factory DueResponseModel.fromJson(Map<String, dynamic> json) {
    return DueResponseModel(
      success: json['success'],
      message: json['message'],
      dueList: ((json['data'] != null && json['data']['dues'] != null)
              ? (json['data']['dues'] as List)
              : [])
          .map((e) => DueModel.fromJson(e))
          .toList(),
    );
  }
}
