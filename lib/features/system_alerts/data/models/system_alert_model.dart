import 'package:equatable/equatable.dart';

class SystemAlertResponse extends Equatable {
  final bool success;
  final String message;
  final List<SystemAlert> alerts;
  final Pagination? pagination;

  const SystemAlertResponse({
    required this.success,
    required this.message,
    required this.alerts,
    this.pagination,
  });

  factory SystemAlertResponse.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return const SystemAlertResponse(
        success: false,
        message: 'Invalid response format',
        alerts: [],
      );
    }
    return SystemAlertResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      alerts: (json['data'] as List?)
              ?.where((e) => e is Map<String, dynamic>)
              .map((e) => SystemAlert.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: (json['pagination'] != null && json['pagination'] is Map)
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  @override
  List<Object?> get props => [success, message, alerts, pagination];
}

class SystemAlert extends Equatable {
  final String id;
  final String type;
  final String severity;
  final String status;
  final String message;
  final AlertUser? user;
  final AlertKiosk? kiosk;
  final Map<String, dynamic>? details;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String summary;

  const SystemAlert({
    required this.id,
    required this.type,
    required this.severity,
    required this.status,
    required this.message,
    this.user,
    this.kiosk,
    this.details,
    required this.createdAt,
    required this.updatedAt,
    required this.summary,
  });

  factory SystemAlert.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return SystemAlert(
        id: '',
        type: '',
        severity: '',
        status: '',
        message: 'Invalid alert data',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        summary: '',
      );
    }
    return SystemAlert(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      severity: json['severity']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      user: (json['user'] != null && json['user'] is Map)
          ? AlertUser.fromJson(json['user'])
          : null,
      kiosk: (json['kiosk'] != null && json['kiosk'] is Map)
          ? AlertKiosk.fromJson(json['kiosk'])
          : null,
      details:
          (json['details'] != null && json['details'] is Map<String, dynamic>)
              ? json['details'] as Map<String, dynamic>
              : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      summary: json['summary']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        severity,
        status,
        message,
        user,
        kiosk,
        details,
        createdAt,
        updatedAt,
        summary
      ];
}

class AlertUser extends Equatable {
  final String id;
  final String fullName;
  final String phone;

  const AlertUser({
    required this.id,
    required this.fullName,
    required this.phone,
  });

  factory AlertUser.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>)
      return const AlertUser(id: '', fullName: '', phone: '');
    return AlertUser(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [id, fullName, phone];
}

class AlertKiosk extends Equatable {
  final String id;
  final String name;

  const AlertKiosk({
    required this.id,
    required this.name,
  });

  factory AlertKiosk.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>)
      return const AlertKiosk(id: '', name: '');
    return AlertKiosk(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name];
}

class Pagination extends Equatable {
  final int page;
  final int limit;
  final int total;
  final int pages;

  const Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory Pagination.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>)
      return const Pagination(page: 1, limit: 10, total: 0, pages: 1);
    return Pagination(
      page: int.tryParse(json['page']?.toString() ?? '1') ?? 1,
      limit: int.tryParse(json['limit']?.toString() ?? '10') ?? 10,
      total: int.tryParse(json['total']?.toString() ?? '0') ?? 0,
      pages: int.tryParse(json['pages']?.toString() ?? '1') ?? 1,
    );
  }

  @override
  List<Object?> get props => [page, limit, total, pages];
}
