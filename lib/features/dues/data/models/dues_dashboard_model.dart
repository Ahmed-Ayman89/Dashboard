class DuesDashboardModel {
  final DuesSummary summary;
  final List<TopKiosk> topKiosks;
  final int highRiskCount;
  final List<HighRiskKiosk> highRiskKiosks;

  DuesDashboardModel({
    required this.summary,
    required this.topKiosks,
    required this.highRiskCount,
    required this.highRiskKiosks,
  });

  factory DuesDashboardModel.fromJson(Map<String, dynamic> json) {
    return DuesDashboardModel(
      summary: DuesSummary.fromJson(json['summary'] ?? {}),
      topKiosks: (json['top_kiosks'] as List? ?? [])
          .map((e) => TopKiosk.fromJson(e))
          .toList(),
      highRiskCount: json['high_risk_count'] ?? 0,
      highRiskKiosks: (json['high_risk_kiosks'] as List? ?? [])
          .map((e) => HighRiskKiosk.fromJson(e))
          .toList(),
    );
  }
}

class DuesSummary {
  final String totalOutstanding;
  final double amountCollectedToday;
  final int count;

  DuesSummary({
    required this.totalOutstanding,
    required this.amountCollectedToday,
    required this.count,
  });

  factory DuesSummary.fromJson(Map<String, dynamic> json) {
    return DuesSummary(
      totalOutstanding: json['total_outstanding']?.toString() ?? '0',
      amountCollectedToday:
          double.tryParse(json['amount_collected_today']?.toString() ?? '0') ??
              0.0,
      count: json['count'] ?? 0,
    );
  }
}

class TopKiosk {
  final String dueId;
  final String kioskId;
  final String kioskName;
  final String owner;
  final String totalDue;
  final String? lastCollectedAt;
  final String createdAt;

  TopKiosk({
    required this.dueId,
    required this.kioskId,
    required this.kioskName,
    required this.owner,
    required this.totalDue,
    this.lastCollectedAt,
    required this.createdAt,
  });

  factory TopKiosk.fromJson(Map<String, dynamic> json) {
    return TopKiosk(
      dueId: json['due_id']?.toString() ?? '',
      kioskId: json['kiosk_id']?.toString() ?? '',
      kioskName: json['kiosk_name']?.toString() ?? '',
      owner: json['owner']?.toString() ?? '',
      totalDue: json['total_due']?.toString() ?? '0',
      lastCollectedAt: json['last_collected_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}

class HighRiskKiosk {
  final String dueId;
  final String kioskId;
  final String name;
  final String reason;
  final String amount;
  final String? lastCollectedAt;
  final String createdAt;

  HighRiskKiosk({
    required this.dueId,
    required this.kioskId,
    required this.name,
    required this.reason,
    required this.amount,
    this.lastCollectedAt,
    required this.createdAt,
  });

  factory HighRiskKiosk.fromJson(Map<String, dynamic> json) {
    return HighRiskKiosk(
      dueId: json['due_id']?.toString() ?? '',
      kioskId: json['kiosk_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '0',
      lastCollectedAt: json['last_collected_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}

class DuesDashboardResponse {
  final bool success;
  final String message;
  final DuesDashboardModel data;

  DuesDashboardResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DuesDashboardResponse.fromJson(Map<String, dynamic> json) {
    return DuesDashboardResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: DuesDashboardModel.fromJson(json['data'] ?? {}),
    );
  }
}
