// Removed unused import

enum OwnerStatus {
  pending,
  approved,
  suspended,
  rejected,
  freezed,
}

class OwnerModel {
  final String id;
  final String name;
  final String phone;
  final OwnerStatus status;
  final String? profileImage;
  final DateTime createdAt;
  final double balance;
  final int totalKiosks;

  const OwnerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.status,
    this.profileImage,
    required this.createdAt,
    required this.balance,
    required this.totalKiosks,
  });
}
