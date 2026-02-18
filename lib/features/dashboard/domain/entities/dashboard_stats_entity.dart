import 'package:equatable/equatable.dart';

class DashboardStatsEntity extends Equatable {
  final List<Alert> alerts;
  final List<Owner> unapprovedOwners;
  final List<RedemptionRequest> redemptionRequests;
  final List<OverdueDueEntity> overdueDues;
  final List<CustomerSignupEntity> customerSignups;
  final DashboardTotals totals;

  const DashboardStatsEntity({
    required this.alerts,
    required this.unapprovedOwners,
    required this.redemptionRequests,
    required this.overdueDues,
    required this.customerSignups,
    required this.totals,
  });

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

class Alert extends Equatable {
  final String id;
  final String type;
  final String severity;
  final String message;
  final String createdAt;
  final String? userName;
  final String? kioskName;

  const Alert({
    required this.id,
    required this.type,
    required this.severity,
    required this.message,
    required this.createdAt,
    this.userName,
    this.kioskName,
  });

  @override
  List<Object?> get props =>
      [id, type, severity, message, createdAt, userName, kioskName];
}

class Owner extends Equatable {
  final String id;
  final String fullName;
  final String phone;

  const Owner({
    required this.id,
    required this.fullName,
    required this.phone,
  });

  @override
  List<Object?> get props => [id, fullName, phone];
}

class RedemptionRequest extends Equatable {
  final String id;
  final String amount;
  final String method;
  final String createdAt;
  final String? userName;

  const RedemptionRequest({
    required this.id,
    required this.amount,
    required this.method,
    required this.createdAt,
    this.userName,
  });

  @override
  List<Object?> get props => [id, amount, method, createdAt, userName];
}

class CustomerSignupEntity extends Equatable {
  final String id;
  final String fullName;
  final String phone;
  final String createdAt;

  const CustomerSignupEntity({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, fullName, phone, createdAt];
}

class OverdueDueEntity extends Equatable {
  final String id;
  final String amount;
  final String createdAt;
  final String? lastCollectedAt;
  final String kioskName;
  final String ownerName;

  const OverdueDueEntity({
    required this.id,
    required this.amount,
    required this.createdAt,
    this.lastCollectedAt,
    required this.kioskName,
    required this.ownerName,
  });

  @override
  List<Object?> get props =>
      [id, amount, createdAt, lastCollectedAt, kioskName, ownerName];
}

class DashboardTotals extends Equatable {
  final int kiosks;
  final int workers;
  final int customers;
  final int transactions;
  final String pointsSent;
  final String duesPending;

  const DashboardTotals({
    required this.kiosks,
    required this.workers,
    required this.customers,
    required this.transactions,
    required this.pointsSent,
    required this.duesPending,
  });

  @override
  List<Object?> get props =>
      [kiosks, workers, customers, transactions, pointsSent, duesPending];
}
