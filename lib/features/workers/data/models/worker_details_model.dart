class WorkerDetailsModel {
  final WorkerProfile profile;
  final double balance;
  final List<WorkerKioskDetail> kiosks;
  final int suspiciousFlags;
  final List<WorkerTransaction> recentTransactions;

  WorkerDetailsModel({
    required this.profile,
    required this.balance,
    required this.kiosks,
    required this.suspiciousFlags,
    required this.recentTransactions,
  });

  factory WorkerDetailsModel.fromJson(Map<String, dynamic> json) {
    return WorkerDetailsModel(
      profile: WorkerProfile.fromJson(json['profile'] ?? {}),
      balance: double.tryParse(json['balance']?.toString() ?? '0') ?? 0.0,
      kiosks: (json['kiosks'] as List? ?? [])
          .map((e) => WorkerKioskDetail.fromJson(e))
          .toList(),
      suspiciousFlags: json['suspicious_flags'] ?? 0,
      recentTransactions: (json['recent_transactions'] as List? ?? [])
          .map((e) => WorkerTransaction.fromJson(e))
          .toList(),
    );
  }
}

class WorkerProfile {
  final String id;
  final String fullName;
  final String phone;
  final bool isActive;
  final bool isVerified;
  final DateTime createdAt;
  final double goalCompletionRate;

  WorkerProfile({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.isActive,
    required this.isVerified,
    required this.createdAt,
    required this.goalCompletionRate,
  });

  factory WorkerProfile.fromJson(Map<String, dynamic> json) {
    return WorkerProfile(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      isActive: json['is_active'] ?? false,
      isVerified: json['is_verified'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      goalCompletionRate:
          double.tryParse(json['goal_completion_rate']?.toString() ?? '0') ??
              0.0,
    );
  }
}

class WorkerKioskDetail {
  final String kioskId;
  final String kioskName;
  final String ownerName;
  final String status;
  final List<WorkerKioskGoal> goals;

  WorkerKioskDetail({
    required this.kioskId,
    required this.kioskName,
    required this.ownerName,
    required this.status,
    required this.goals,
  });

  factory WorkerKioskDetail.fromJson(Map<String, dynamic> json) {
    return WorkerKioskDetail(
      kioskId: json['kiosk_id'] ?? '',
      kioskName: json['kiosk_name'] ?? '',
      ownerName: json['owner_name'] ?? '',
      status: json['status'] ?? '',
      goals: (json['goals'] as List? ?? [])
          .map((e) => WorkerKioskGoal.fromJson(e))
          .toList(),
    );
  }
}

class WorkerKioskGoal {
  final String date;
  final double commission;
  final double targetAmount;
  final String status;

  WorkerKioskGoal({
    required this.date,
    required this.commission,
    required this.targetAmount,
    required this.status,
  });

  factory WorkerKioskGoal.fromJson(Map<String, dynamic> json) {
    return WorkerKioskGoal(
      date: json['date'] ?? '',
      commission: double.tryParse(json['commission']?.toString() ?? '0') ?? 0.0,
      targetAmount:
          double.tryParse(json['targetAmount']?.toString() ?? '0') ?? 0.0,
      status: json['status'] ?? '',
    );
  }
}

class WorkerTransaction {
  final String id;
  final String receiverPhone;
  final double amountGross;
  final double commission;
  final DateTime createdAt;

  WorkerTransaction({
    required this.id,
    required this.receiverPhone,
    required this.amountGross,
    required this.commission,
    required this.createdAt,
  });

  factory WorkerTransaction.fromJson(Map<String, dynamic> json) {
    return WorkerTransaction(
      id: json['id'] ?? '',
      receiverPhone: json['receiver_phone'] ?? '',
      amountGross:
          double.tryParse(json['amount_gross']?.toString() ?? '0') ?? 0.0,
      commission: double.tryParse(json['commission']?.toString() ?? '0') ?? 0.0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
