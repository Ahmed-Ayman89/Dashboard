import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class GraphDataPointModel extends Equatable {
  final String label;
  final double value;
  final DateTime? date;
  final int? count;
  final double? volume;

  const GraphDataPointModel({
    required this.label,
    required this.value,
    this.date,
    this.count,
    this.volume,
  });

  factory GraphDataPointModel.fromJson(Map<String, dynamic> json) {
    // Parse the date
    final dateStr = json['date'] as String?;
    final parsedDate = dateStr != null ? DateTime.tryParse(dateStr) : null;

    // Use label from JSON if available, otherwise try period, otherwise fall back to date formatting
    String label = json['label'] as String? ?? json['period'] as String? ?? '';

    if (label.isEmpty && parsedDate != null) {
      // If we still don't have a label but have a date, format it
      // Defaulting to day name for weekly, but we could be smarter here if we had the filter
      label = DateFormat('EEE').format(parsedDate);
    } else if (label.isEmpty && dateStr != null) {
      // If date parsing failed but we have a raw date string, use it as label
      label = dateStr;
    }

    // Get count and volume
    final count = json['count'] as int? ?? 0;
    final volume = (json['volume'] as num?)?.toDouble() ?? 0.0;

    // Determine value: use volume if present in JSON, otherwise fallback to count
    double value;
    if (json.containsKey('volume') && json['volume'] != null) {
      value = volume;
    } else {
      value = count.toDouble();
    }

    return GraphDataPointModel(
      label: label,
      value: value,
      date: parsedDate,
      count: count,
      volume: volume,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      if (date != null) 'date': date!.toIso8601String(),
      if (count != null) 'count': count,
      if (volume != null) 'volume': volume,
    };
  }

  @override
  List<Object?> get props => [label, value, date, count, volume];
}
