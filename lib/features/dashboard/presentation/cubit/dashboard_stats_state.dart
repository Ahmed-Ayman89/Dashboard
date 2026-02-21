import 'package:equatable/equatable.dart';
import '../../domain/entities/dashboard_stats_entity.dart';

abstract class DashboardStatsState extends Equatable {
  const DashboardStatsState();

  @override
  List<Object> get props => [];
}

class DashboardStatsInitial extends DashboardStatsState {}

class DashboardStatsLoading extends DashboardStatsState {}

class DashboardStatsSuccess extends DashboardStatsState {
  final DashboardStatsEntity stats;

  const DashboardStatsSuccess(this.stats);

  @override
  List<Object> get props => [stats];
}

class DashboardStatsPendingApproval extends DashboardStatsState {}

class DashboardStatsError extends DashboardStatsState {
  final String message;

  const DashboardStatsError(this.message);

  @override
  List<Object> get props => [message];
}
