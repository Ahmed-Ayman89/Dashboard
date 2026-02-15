class WorkerGraphModel {
  final String workerId;
  final String resource;
  final String period;
  final String interval;
  final List<WorkerGraphDataPoint> data;

  WorkerGraphModel({
    required this.workerId,
    required this.resource,
    required this.period,
    required this.interval,
    required this.data,
  });

  factory WorkerGraphModel.fromJson(Map<String, dynamic> json) {
    return WorkerGraphModel(
      workerId: json['worker_id'] ?? '',
      resource: json['resource'] ?? '',
      period: json['period'] ?? '',
      interval: json['interval'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => WorkerGraphDataPoint.fromJson(e))
          .toList(),
    );
  }
}

class WorkerGraphDataPoint {
  final DateTime date;
  final int count;
  final double volume;
  final String label;

  WorkerGraphDataPoint({
    required this.date,
    required this.count,
    required this.volume,
    required this.label,
  });

  factory WorkerGraphDataPoint.fromJson(Map<String, dynamic> json) {
    return WorkerGraphDataPoint(
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      count: json['count'] ?? 0,
      volume: double.tryParse(json['volume']?.toString() ?? '0') ?? 0.0,
      label: json['date'] ?? json['label'] ?? json['period'] ?? '',
    );
  }
}
