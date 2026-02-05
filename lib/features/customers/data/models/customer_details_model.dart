class CustomerDetailsModel {
  final CustomerProfile profile;
  final double balance;
  final double totalPointsReceived;
  final int totalTransactions;
  final List<CustomerSpace> spaces;
  final List<CustomerKioskInteraction> kioskInteractions;
  final List<CustomerTransaction> recentTransactions;

  CustomerDetailsModel({
    required this.profile,
    required this.balance,
    required this.totalPointsReceived,
    required this.totalTransactions,
    required this.spaces,
    required this.kioskInteractions,
    required this.recentTransactions,
  });

  factory CustomerDetailsModel.fromJson(Map<String, dynamic> json) {
    return CustomerDetailsModel(
      profile: CustomerProfile.fromJson(json['profile'] ?? {}),
      balance: double.tryParse(json['balance']?.toString() ?? '0') ?? 0.0,
      totalPointsReceived:
          double.tryParse(json['total_points_received']?.toString() ?? '0') ??
              0.0,
      totalTransactions: json['total_transactions'] ?? 0,
      spaces: (json['spaces'] as List? ?? [])
          .map((e) => CustomerSpace.fromJson(e))
          .toList(),
      kioskInteractions: (json['kiosk_interactions'] as List? ?? [])
          .map((e) => CustomerKioskInteraction.fromJson(e))
          .toList(),
      recentTransactions: (json['recent_transactions'] as List? ?? [])
          .map((e) => CustomerTransaction.fromJson(e))
          .toList(),
    );
  }
}

class CustomerProfile {
  final String id;
  final String fullName;
  final String phone;
  final bool isActive;
  final bool isVerified;
  final bool appDownloaded;
  final DateTime createdAt;

  CustomerProfile({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.isActive,
    required this.isVerified,
    required this.appDownloaded,
    required this.createdAt,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      isActive: json['is_active'] ?? false,
      isVerified: json['is_verified'] ?? false,
      appDownloaded: json['app_downloaded'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class CustomerSpace {
  final String id;
  final String name;
  final double balance;
  final double target;
  final DateTime deadline;

  CustomerSpace({
    required this.id,
    required this.name,
    required this.balance,
    required this.target,
    required this.deadline,
  });

  factory CustomerSpace.fromJson(Map<String, dynamic> json) {
    return CustomerSpace(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      balance: double.tryParse(json['balance']?.toString() ?? '0') ?? 0.0,
      target: double.tryParse(json['target']?.toString() ?? '0') ?? 0.0,
      deadline: DateTime.tryParse(json['deadline'] ?? '') ?? DateTime.now(),
    );
  }
}

class CustomerKioskInteraction {
  final String kioskId;
  final String kioskName;
  final int transactionCount;
  final double totalReceived;

  CustomerKioskInteraction({
    required this.kioskId,
    required this.kioskName,
    required this.transactionCount,
    required this.totalReceived,
  });

  factory CustomerKioskInteraction.fromJson(Map<String, dynamic> json) {
    return CustomerKioskInteraction(
      kioskId: json['kiosk_id'] ?? '',
      kioskName: json['kiosk_name'] ?? '',
      transactionCount: json['transaction_count'] ?? 0,
      totalReceived:
          double.tryParse(json['total_received']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class CustomerTransaction {
  final String id;
  final double amount;
  final String kioskName;
  final DateTime createdAt;

  CustomerTransaction({
    required this.id,
    required this.amount,
    required this.kioskName,
    required this.createdAt,
  });

  factory CustomerTransaction.fromJson(Map<String, dynamic> json) {
    return CustomerTransaction(
      id: json['id'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      kioskName: json['kiosk_name'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
