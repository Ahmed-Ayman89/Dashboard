import 'package:equatable/equatable.dart';
import 'package:dashboard_grow/features/system_alerts/data/models/system_alert_model.dart';

abstract class AlertsState extends Equatable {
  const AlertsState();

  @override
  List<Object?> get props => [];
}

class AlertsInitial extends AlertsState {}

class AlertsLoading extends AlertsState {}

class AlertsLoaded extends AlertsState {
  final List<SystemAlert> alerts;
  final Pagination? pagination;

  const AlertsLoaded({required this.alerts, this.pagination});

  @override
  List<Object?> get props => [alerts, pagination];
}

class AlertsFailure extends AlertsState {
  final String message;

  const AlertsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class AlertsFetchingMore extends AlertsLoaded {
  const AlertsFetchingMore({required super.alerts, super.pagination});
}
