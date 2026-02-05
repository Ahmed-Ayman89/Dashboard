class WorkerModel {
  final String id;
  final String fullName;
  final String phone;
  final bool isActive;
  final double balance;
  final int transactionsCount;
  final double commissionEarned;
  final DateTime createdAt;
  final List<WorkerKiosk> kiosks;

  WorkerModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.isActive,
    required this.balance,
    required this.transactionsCount,
    required this.commissionEarned,
    required this.createdAt,
    required this.kiosks,
  });

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    return WorkerModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      isActive: json['is_active'] ?? false,
      balance: double.tryParse(json['balance']?.toString() ?? '0') ?? 0.0,
      transactionsCount: json['transactions_count'] ?? 0,
      commissionEarned:
          double.tryParse(json['commission_earned']?.toString() ?? '0') ?? 0.0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      kiosks: (json['kiosks'] as List? ?? [])
          .map((e) => WorkerKiosk.fromJson(e))
          .toList(),
    );
  }
}

class WorkerKiosk {
  final String id;
  final String name;
  final String owner;
  final String status;

  WorkerKiosk({
    required this.id,
    required this.name,
    required this.owner,
    required this.status,
  });

  factory WorkerKiosk.fromJson(Map<String, dynamic> json) {
    return WorkerKiosk(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      owner: json['owner'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
