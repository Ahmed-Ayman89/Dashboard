import 'package:equatable/equatable.dart';

class DashboardStatsEntity extends Equatable {
  final List<Alert> alerts;
  final List<Owner> unapprovedOwners;
  final List<RedemptionRequest> redemptionRequests;
  final int kiosksDuesCount;
  final int customerSignupsCount;
  final DashboardTotals totals;

  const DashboardStatsEntity({
    required this.alerts,
    required this.unapprovedOwners,
    required this.redemptionRequests,
    required this.kiosksDuesCount,
    required this.customerSignupsCount,
    required this.totals,
  });

  @override
  List<Object?> get props => [
        alerts,
        unapprovedOwners,
        redemptionRequests,
        kiosksDuesCount,
        customerSignupsCount,
        totals
      ];
}

class Alert extends Equatable {
  final String id;
  final String type;
  final String severity;
  final String message;

  const Alert({
    required this.id,
    required this.type,
    required this.severity,
    required this.message,
  });

  @override
  List<Object?> get props => [id, type, severity, message];
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

  const RedemptionRequest({
    required this.id,
    required this.amount,
    required this.method,
  });

  @override
  List<Object?> get props => [id, amount, method];
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
