class CustomerModel {
  final String id;
  final String fullName;
  final String phone;
  final bool isActive;
  final double balance;
  final double totalPointsReceived;
  final int redemptionCount;
  final int kiosksInteracted;
  final bool appDownloaded;
  final DateTime createdAt;

  CustomerModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.isActive,
    required this.balance,
    required this.totalPointsReceived,
    required this.redemptionCount,
    required this.kiosksInteracted,
    required this.appDownloaded,
    required this.createdAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      isActive: json['is_active'] ?? false,
      balance: double.tryParse(json['balance']?.toString() ?? '0') ?? 0.0,
      totalPointsReceived:
          double.tryParse(json['total_points_received']?.toString() ?? '0') ??
              0.0,
      redemptionCount: json['redemption_count'] ?? 0,
      kiosksInteracted: json['kiosks_interacted'] ?? 0,
      appDownloaded: json['app_downloaded'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
