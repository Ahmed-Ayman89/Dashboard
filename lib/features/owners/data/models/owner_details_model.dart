class OwnerDetailsModel {
  final OwnerProfile profile;
  final OwnerFinancials financials;
  final OwnerActivity activity;
  final List<OwnerKioskItem> kiosks;
  final OwnerHistory history;

  OwnerDetailsModel({
    required this.profile,
    required this.financials,
    required this.activity,
    required this.kiosks,
    required this.history,
  });

  factory OwnerDetailsModel.fromJson(Map<String, dynamic> json) {
    return OwnerDetailsModel(
      profile: OwnerProfile.fromJson(json['profile'] ?? {}),
      financials: OwnerFinancials.fromJson(json['financials'] ?? {}),
      activity: OwnerActivity.fromJson(json['activity'] ?? {}),
      kiosks: (json['kiosks'] as List<dynamic>?)
              ?.map((e) => OwnerKioskItem.fromJson(e))
              .toList() ??
          [],
      history: OwnerHistory.fromJson(json['history'] ?? {}),
    );
  }
}

class OwnerProfile {
  final String id;
  final String fullName;
  final String phone;
  final String status;
  final String verificationStatus;
  final String? adminNotes;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final bool isVerified;

  OwnerProfile({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.status,
    required this.verificationStatus,
    this.adminNotes,
    this.lastLoginAt,
    required this.createdAt,
    required this.isVerified,
  });

  factory OwnerProfile.fromJson(Map<String, dynamic> json) {
    return OwnerProfile(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      status: json['status'] ?? 'PENDING',
      verificationStatus: json['verification_status'] ?? 'PENDING',
      adminNotes: json['admin_notes'],
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.tryParse(json['last_login_at'])
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      isVerified: json['is_verified'] ?? false,
    );
  }
}

class OwnerFinancials {
  final double walletBalance;
  final double totalDuesPending;
  final double totalCommissionEarned;
  final double monthlyCommissionEarned;
  final double monthlyVolume;
  final int monthlyTransactions;

  OwnerFinancials({
    required this.walletBalance,
    required this.totalDuesPending,
    required this.totalCommissionEarned,
    required this.monthlyCommissionEarned,
    required this.monthlyVolume,
    required this.monthlyTransactions,
  });

  factory OwnerFinancials.fromJson(Map<String, dynamic> json) {
    return OwnerFinancials(
      walletBalance:
          double.tryParse(json['wallet_balance']?.toString() ?? '0') ?? 0,
      totalDuesPending:
          double.tryParse(json['total_dues_pending']?.toString() ?? '0') ?? 0,
      totalCommissionEarned:
          double.tryParse(json['total_commission_earned']?.toString() ?? '0') ??
              0,
      monthlyCommissionEarned: double.tryParse(
              json['monthly_commission_earned']?.toString() ?? '0') ??
          0,
      monthlyVolume:
          double.tryParse(json['monthly_volume']?.toString() ?? '0') ?? 0,
      monthlyTransactions: json['monthly_transactions'] ?? 0,
    );
  }
}

class OwnerActivity {
  final int totalTransactions;
  final double totalVolume;
  final int invitationsSent;

  OwnerActivity({
    required this.totalTransactions,
    required this.totalVolume,
    required this.invitationsSent,
  });

  factory OwnerActivity.fromJson(Map<String, dynamic> json) {
    return OwnerActivity(
      totalTransactions: json['total_transactions'] ?? 0,
      totalVolume:
          double.tryParse(json['total_volume']?.toString() ?? '0') ?? 0,
      invitationsSent: json['invitations_sent'] ?? 0,
    );
  }
}

class OwnerKioskItem {
  final String id;
  final String name;
  final int workersCount;
  final double pendingDues;
  final List<OwnerWorkerItem> workers;

  OwnerKioskItem({
    required this.id,
    required this.name,
    required this.workersCount,
    required this.pendingDues,
    required this.workers,
  });

  factory OwnerKioskItem.fromJson(Map<String, dynamic> json) {
    return OwnerKioskItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      workersCount: json['workers_count'] ?? 0,
      pendingDues:
          double.tryParse(json['pending_dues']?.toString() ?? '0') ?? 0,
      workers: (json['workers'] as List<dynamic>?)
              ?.map((e) => OwnerWorkerItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class OwnerWorkerItem {
  final String id;
  final String fullName;
  final String phone;

  OwnerWorkerItem({
    required this.id,
    required this.fullName,
    required this.phone,
  });

  factory OwnerWorkerItem.fromJson(Map<String, dynamic> json) {
    return OwnerWorkerItem(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

class OwnerHistory {
  final List<OwnerRedemptionItem> redemptions;
  final List<OwnerTransactionItem> transactions;

  OwnerHistory({
    required this.redemptions,
    required this.transactions,
  });

  factory OwnerHistory.fromJson(Map<String, dynamic> json) {
    return OwnerHistory(
      redemptions: (json['redemptions'] as List<dynamic>?)
              ?.map((e) => OwnerRedemptionItem.fromJson(e))
              .toList() ??
          [],
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map((e) => OwnerTransactionItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class OwnerRedemptionItem {
  final String id;
  final double amount;
  final DateTime createdAt;
  final String status;
  final String? adminNote;

  OwnerRedemptionItem({
    required this.id,
    required this.amount,
    required this.createdAt,
    required this.status,
    this.adminNote,
  });

  factory OwnerRedemptionItem.fromJson(Map<String, dynamic> json) {
    return OwnerRedemptionItem(
      id: json['id'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'PENDING',
      adminNote: json['admin_note'],
    );
  }
}

class OwnerTransactionItem {
  final String id;
  final double amountGross;
  final double commission;
  final DateTime createdAt;
  final String kioskName;

  OwnerTransactionItem({
    required this.id,
    required this.amountGross,
    required this.commission,
    required this.createdAt,
    required this.kioskName,
  });

  factory OwnerTransactionItem.fromJson(Map<String, dynamic> json) {
    return OwnerTransactionItem(
      id: json['id'] ?? '',
      amountGross:
          double.tryParse(json['amount_gross']?.toString() ?? '0') ?? 0,
      commission: double.tryParse(json['commission']?.toString() ?? '0') ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      kioskName: json['kiosk']?['name'] ?? 'Unknown Kiosk',
    );
  }
}
