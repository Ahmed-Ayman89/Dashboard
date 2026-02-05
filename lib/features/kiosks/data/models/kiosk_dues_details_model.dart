class KioskDuesDetailsModel {
  final String kioskId;
  final String name;
  final DuesFinancials financials;
  final List<DuesHistoryItem> duesHistory;
  final List<ContributingWorker> workersContributing;

  KioskDuesDetailsModel({
    required this.kioskId,
    required this.name,
    required this.financials,
    required this.duesHistory,
    required this.workersContributing,
  });

  factory KioskDuesDetailsModel.fromJson(Map<String, dynamic> json) {
    return KioskDuesDetailsModel(
      kioskId: json['kiosk_id'] ?? '',
      name: json['name'] ?? '',
      financials: DuesFinancials.fromJson(json['financials'] ?? {}),
      duesHistory: (json['dues_history'] as List? ?? [])
          .map((e) => DuesHistoryItem.fromJson(e))
          .toList(),
      workersContributing: (json['workers_contributing'] as List? ?? [])
          .map((e) => ContributingWorker.fromJson(e))
          .toList(),
    );
  }
}

class DuesFinancials {
  final double totalDuesGenerated;
  final double totalPaid;
  final double outstandingBalance;

  DuesFinancials({
    required this.totalDuesGenerated,
    required this.totalPaid,
    required this.outstandingBalance,
  });

  factory DuesFinancials.fromJson(Map<String, dynamic> json) {
    return DuesFinancials(
      totalDuesGenerated: (json['total_dues_generated'] ?? 0).toDouble(),
      totalPaid: (json['total_paid'] ?? 0).toDouble(),
      outstandingBalance: (json['outstanding_balance'] ?? 0).toDouble(),
    );
  }
}

class DuesHistoryItem {
  final String id;
  final double amount;
  final bool isPaid;
  final DateTime createdAt;

  DuesHistoryItem({
    required this.id,
    required this.amount,
    required this.isPaid,
    required this.createdAt,
  });

  factory DuesHistoryItem.fromJson(Map<String, dynamic> json) {
    return DuesHistoryItem(
      id: json['id'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      isPaid: json['is_paid'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class ContributingWorker {
  final String name;
  final String status;

  ContributingWorker({
    required this.name,
    required this.status,
  });

  factory ContributingWorker.fromJson(Map<String, dynamic> json) {
    return ContributingWorker(
      name: json['name'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
