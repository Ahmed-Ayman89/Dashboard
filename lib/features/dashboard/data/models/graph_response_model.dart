import 'package:equatable/equatable.dart';
import 'graph_data_point_model.dart';
import '../../domain/entities/graph_entity.dart';

class GraphResponseModel extends Equatable {
  final List<GraphDataPointModel> dataPoints;
  final String filter;
  final String resource;
  final int totalCount;
  final double totalVolume;

  const GraphResponseModel({
    required this.dataPoints,
    required this.filter,
    required this.resource,
    this.totalCount = 0,
    this.totalVolume = 0,
  });

  factory GraphResponseModel.fromJson(Map<String, dynamic> json) {
    // Handle the actual API response structure
    List<dynamic> dataList = [];
    String filter = 'weekly';
    String resource = 'transactions';
    int totalCount = 0;
    double totalVolume = 0;

    if (json['data'] is Map) {
      final dataMap = json['data'] as Map<String, dynamic>;
      // The actual data array is nested inside data.data
      dataList = dataMap['data'] as List<dynamic>? ?? [];
      // Get filter/resource from the response
      filter = dataMap['period'] as String? ?? 'weekly';
      resource = dataMap['resource'] as String? ?? 'transactions';
      totalCount = dataMap['total_count'] as int? ?? 0;
      totalVolume = (dataMap['total_volume'] as num?)?.toDouble() ?? 0.0;
    } else if (json['data'] is List) {
      // Fallback for direct array structure
      dataList = json['data'] as List<dynamic>;
    }

    return GraphResponseModel(
      dataPoints: dataList
          .map((item) =>
              GraphDataPointModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      filter: filter,
      resource: resource,
      totalCount: totalCount,
      totalVolume: totalVolume,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': dataPoints.map((point) => point.toJson()).toList(),
      'filter': filter,
      'resource': resource,
    };
  }

  GraphEntity toEntity() {
    return GraphEntity(
      dataPoints: dataPoints
          .map((point) => GraphDataPoint(
                label: point.label,
                value: point.value,
                date: point.date,
              ))
          .toList(),
      filter: filter,
      resource: resource,
      totalCount: totalCount,
      totalVolume: totalVolume,
    );
  }

  @override
  List<Object?> get props =>
      [dataPoints, filter, resource, totalCount, totalVolume];
}
