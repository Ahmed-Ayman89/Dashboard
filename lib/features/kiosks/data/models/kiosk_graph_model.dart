class KioskGraphModel {
  final String kioskId;
  final String resource;
  final String period;
  final String interval;
  final List<KioskGraphDataPoint> data;

  KioskGraphModel({
    required this.kioskId,
    required this.resource,
    required this.period,
    required this.interval,
    required this.data,
  });

  factory KioskGraphModel.fromJson(Map<String, dynamic> json) {
    return KioskGraphModel(
      kioskId: json['kiosk_id'] ?? '',
      resource: json['resource'] ?? '',
      period: json['period'] ?? '7d', // Default as per example response
      interval: json['interval'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => KioskGraphDataPoint.fromJson(e))
          .toList(),
    );
  }
}

class KioskGraphDataPoint {
  final DateTime date;
  final int count;
  final double volume;
  final String label;

  KioskGraphDataPoint({
    required this.date,
    required this.count,
    required this.volume,
    required this.label,
  });

  factory KioskGraphDataPoint.fromJson(Map<String, dynamic> json) {
    return KioskGraphDataPoint(
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      count: json['count'] ?? 0,
      volume: double.tryParse(json['volume']?.toString() ?? '0') ?? 0.0,
      label: json['date'] ?? json['label'] ?? json['period'] ?? '',
    );
  }
}
