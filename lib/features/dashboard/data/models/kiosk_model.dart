class KioskModel {
  final String id;
  final String name;
  final String? location;
  final String? address;
  final bool isActive;
  final KioskOwner owner;
  final int workersCount;
  final int totalTransactions;
  final int dailyTransactions;
  final num pendingDues;
  final DateTime createdAt;

  const KioskModel({
    required this.id,
    required this.name,
    this.location,
    this.address,
    required this.isActive,
    required this.owner,
    required this.workersCount,
    required this.totalTransactions,
    required this.dailyTransactions,
    required this.pendingDues,
    required this.createdAt,
  });

  factory KioskModel.fromJson(Map<String, dynamic> json) {
    return KioskModel(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      address: json['address'],
      isActive: json['is_active'],
      owner: KioskOwner.fromJson(json['owner']),
      workersCount: json['workers_count'],
      totalTransactions: json['total_transactions'],
      dailyTransactions: json['daily_transactions'],
      pendingDues: json['pending_dues'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class KioskOwner {
  final String fullName;
  final String phone;

  const KioskOwner({
    required this.fullName,
    required this.phone,
  });

  factory KioskOwner.fromJson(Map<String, dynamic> json) {
    return KioskOwner(
      fullName: json['full_name'],
      phone: json['phone'],
    );
  }
}
