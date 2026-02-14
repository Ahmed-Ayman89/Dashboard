class OwnerGraphModel {
  final String ownerId;
  final String resource;
  final String period;
  final String interval;
  final List<OwnerGraphDataPoint> data;

  OwnerGraphModel({
    required this.ownerId,
    required this.resource,
    required this.period,
    required this.interval,
    required this.data,
  });

  factory OwnerGraphModel.fromJson(Map<String, dynamic> json) {
    return OwnerGraphModel(
      ownerId: json['owner_id'] ?? '',
      resource: json['resource'] ?? '',
      period: json['period'] ?? 'Weekly', // Default to Weekly if missing
      interval: json['interval'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => OwnerGraphDataPoint.fromJson(e))
          .toList(),
    );
  }
}

class OwnerGraphDataPoint {
  final DateTime date;
  final int count;
  final double volume;
  final String label;

  OwnerGraphDataPoint({
    required this.date,
    required this.count,
    required this.volume,
    required this.label,
  });

  factory OwnerGraphDataPoint.fromJson(Map<String, dynamic> json) {
    return OwnerGraphDataPoint(
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      count: json['count'] ?? 0,
      volume: double.tryParse(json['volume']?.toString() ?? '0') ?? 0.0,
      label: json['label'] ?? json['period'] ?? '',
    );
  }
}
