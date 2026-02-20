class KioskGraphModel {
  final String kioskId;
  final String resource;
  final String period;
  final String interval;
  final List<KioskGraphDataPoint> data;
  final int totalCount;
  final double totalVolume;

  KioskGraphModel({
    required this.kioskId,
    required this.resource,
    required this.period,
    required this.interval,
    required this.data,
    this.totalCount = 0,
    this.totalVolume = 0,
  });

  factory KioskGraphModel.fromJson(Map<String, dynamic> json) {
    return KioskGraphModel(
      kioskId: json['kiosk_id'] ?? '',
      resource: json['resource'] ?? '',
      period: json['period'] ?? '7d',
      interval: json['interval'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => KioskGraphDataPoint.fromJson(e))
          .toList(),
      totalCount: json['total_count'] ?? 0,
      totalVolume: (json['total_volume'] as num?)?.toDouble() ?? 0.0,
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
