import 'package:equatable/equatable.dart';
import '../../domain/entities/dashboard_stats_entity.dart';

class AlertModel extends Equatable {
  final String id;
  final String type;
  final String severity;
  final String message;
  final String createdAt;
  final UserInfo? user;
  final KioskInfo? kiosk;

  const AlertModel({
    required this.id,
    required this.type,
    required this.severity,
    required this.message,
    required this.createdAt,
    this.user,
    this.kiosk,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      severity: json['severity'] as String? ?? 'LOW',
      message: json['message'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      user: json['user'] != null
          ? UserInfo.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      kiosk: json['kiosk'] != null
          ? KioskInfo.fromJson(json['kiosk'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props =>
      [id, type, severity, message, createdAt, user, kiosk];
}

class UserInfo extends Equatable {
  final String id;
  final String fullName;
  final String phone;

  const UserInfo({
    required this.id,
    required this.fullName,
    required this.phone,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, fullName, phone];
}

class KioskInfo extends Equatable {
  final String id;
  final String name;

  const KioskInfo({
    required this.id,
    required this.name,
  });

  factory KioskInfo.fromJson(Map<String, dynamic> json) {
    return KioskInfo(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name];
}

class OwnerModel extends Equatable {
  final String id;
  final String fullName;
  final String phone;
  final String createdAt;

  const OwnerModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.createdAt,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      id: json['id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, fullName, phone, createdAt];
}

class RedemptionRequestModel extends Equatable {
  final String id;
  final String amount;
  final String method;
  final String createdAt;
  final UserInfo? user;

  const RedemptionRequestModel({
    required this.id,
    required this.amount,
    required this.method,
    required this.createdAt,
    this.user,
  });

  factory RedemptionRequestModel.fromJson(Map<String, dynamic> json) {
    return RedemptionRequestModel(
      id: json['id'] as String? ?? '',
      amount: json['amount'] as String? ?? '0',
      method: json['method'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      user: json['user'] != null
          ? UserInfo.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [id, amount, method, createdAt, user];
}

class KioskWithOverdueDues extends Equatable {
  final String id;
  final String amount;
  final String createdAt;
  final String? lastCollectedAt;
  final KioskInfoWithOwner kiosk;

  const KioskWithOverdueDues({
    required this.id,
    required this.amount,
    required this.createdAt,
    this.lastCollectedAt,
    required this.kiosk,
  });

  factory KioskWithOverdueDues.fromJson(Map<String, dynamic> json) {
    return KioskWithOverdueDues(
      id: json['id'] as String? ?? '',
      amount: json['amount']?.toString() ?? '0',
      createdAt: json['created_at'] as String? ?? '',
      lastCollectedAt: json['last_collected_at'] as String?,
      kiosk: KioskInfoWithOwner.fromJson(
          json['kiosk'] as Map<String, dynamic>? ?? {}),
    );
  }

  @override
  List<Object?> get props => [id, amount, createdAt, lastCollectedAt, kiosk];
}

class KioskInfoWithOwner extends Equatable {
  final String id;
  final String name;
  final UserInfo? owner;

  const KioskInfoWithOwner({
    required this.id,
    required this.name,
    this.owner,
  });

  factory KioskInfoWithOwner.fromJson(Map<String, dynamic> json) {
    return KioskInfoWithOwner(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      owner: json['owner'] != null
          ? UserInfo.fromJson(json['owner'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [id, name, owner];
}

class CustomerSignup extends Equatable {
  final String id;
  final String fullName;
  final String phone;
  final String createdAt;

  const CustomerSignup({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.createdAt,
  });

  factory CustomerSignup.fromJson(Map<String, dynamic> json) {
    return CustomerSignup(
      id: json['id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, fullName, phone, createdAt];
}

class DashboardTotalsModel extends Equatable {
  final int kiosks;
  final int workers;
  final int customers;
  final int transactions;
  final String pointsSent;
  final String duesPending;

  const DashboardTotalsModel({
    required this.kiosks,
    required this.workers,
    required this.customers,
    required this.transactions,
    required this.pointsSent,
    required this.duesPending,
  });

  factory DashboardTotalsModel.fromJson(Map<String, dynamic> json) {
    return DashboardTotalsModel(
      kiosks: json['kiosks'] as int? ?? 0,
      workers: json['workers'] as int? ?? 0,
      customers: json['customers'] as int? ?? 0,
      transactions: json['transactions'] as int? ?? 0,
      pointsSent: json['points_sent'] as String? ?? '0',
      duesPending: json['dues_pending'] as String? ?? '0',
    );
  }

  @override
  List<Object?> get props =>
      [kiosks, workers, customers, transactions, pointsSent, duesPending];
}

class DashboardStatsModel extends Equatable {
  final List<AlertModel> alerts;
  final List<OwnerModel> unapprovedOwners;
  final List<RedemptionRequestModel> redemptionRequests;
  final List<KioskWithOverdueDues> overdueDues;
  final List<CustomerSignup> customerSignups;
  final DashboardTotalsModel totals;

  const DashboardStatsModel({
    required this.alerts,
    required this.unapprovedOwners,
    required this.redemptionRequests,
    required this.overdueDues,
    required this.customerSignups,
    required this.totals,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final recent = data['recent'] as Map<String, dynamic>? ?? {};

    final alertsList = recent['alerts'] as List<dynamic>? ?? [];
    final ownersList = recent['unapproved_owners'] as List<dynamic>? ?? [];
    final redemptionsList =
        recent['redemption_requests'] as List<dynamic>? ?? [];
    final duesList = recent['kiosks_with_overdue_dues'] as List<dynamic>? ?? [];
    final signupsList = recent['customer_signups'] as List<dynamic>? ?? [];

    return DashboardStatsModel(
      alerts: alertsList
          .map((item) => AlertModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      unapprovedOwners: ownersList
          .map((item) => OwnerModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      redemptionRequests: redemptionsList
          .map((item) =>
              RedemptionRequestModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      overdueDues: duesList
          .map((item) =>
              KioskWithOverdueDues.fromJson(item as Map<String, dynamic>))
          .toList(),
      customerSignups: signupsList
          .map((item) => CustomerSignup.fromJson(item as Map<String, dynamic>))
          .toList(),
      totals: DashboardTotalsModel.fromJson(
          data['totals'] as Map<String, dynamic>? ?? {}),
    );
  }

  DashboardStatsEntity toEntity() {
    return DashboardStatsEntity(
      alerts: alerts
          .map((alert) => Alert(
                id: alert.id,
                type: alert.type,
                severity: alert.severity,
                message: alert.message,
                createdAt: alert.createdAt,
                userName: alert.user?.fullName,
                kioskName: alert.kiosk?.name,
              ))
          .toList(),
      unapprovedOwners: unapprovedOwners
          .map((owner) => Owner(
                id: owner.id,
                fullName: owner.fullName,
                phone: owner.phone,
              ))
          .toList(),
      redemptionRequests: redemptionRequests
          .map((request) => RedemptionRequest(
                id: request.id,
                amount: request.amount,
                method: request.method,
                createdAt: request.createdAt,
                userName: request.user?.fullName,
              ))
          .toList(),
      overdueDues: overdueDues
          .map((due) => OverdueDueEntity(
                id: due.id,
                amount: due.amount,
                createdAt: due.createdAt,
                lastCollectedAt: due.lastCollectedAt,
                kioskName: due.kiosk.name,
                ownerName: due.kiosk.owner?.fullName ?? 'Unknown',
              ))
          .toList(),
      customerSignups: customerSignups
          .map((signup) => CustomerSignupEntity(
                id: signup.id,
                fullName: signup.fullName,
                phone: signup.phone,
                createdAt: signup.createdAt,
              ))
          .toList(),
      totals: DashboardTotals(
        kiosks: totals.kiosks,
        workers: totals.workers,
        customers: totals.customers,
        transactions: totals.transactions,
        pointsSent: totals.pointsSent,
        duesPending: totals.duesPending,
      ),
    );
  }

  @override
  List<Object?> get props => [
        alerts,
        unapprovedOwners,
        redemptionRequests,
        overdueDues,
        customerSignups,
        totals
      ];
}
