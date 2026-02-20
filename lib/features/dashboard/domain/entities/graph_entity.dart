import 'package:equatable/equatable.dart';

class GraphDataPoint extends Equatable {
  final String label;
  final double value;
  final DateTime? date;

  const GraphDataPoint({
    required this.label,
    required this.value,
    this.date,
  });

  @override
  List<Object?> get props => [label, value, date];
}

class GraphEntity extends Equatable {
  final List<GraphDataPoint> dataPoints;
  final String filter;
  final String resource;
  final int totalCount;
  final double totalVolume;

  const GraphEntity({
    required this.dataPoints,
    required this.filter,
    required this.resource,
    this.totalCount = 0,
    this.totalVolume = 0,
  });

  @override
  List<Object?> get props =>
      [dataPoints, filter, resource, totalCount, totalVolume];
}
