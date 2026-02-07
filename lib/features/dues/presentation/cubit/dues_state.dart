part of 'dues_cubit.dart';

sealed class DuesState extends Equatable {
  const DuesState();

  @override
  List<Object> get props => [];
}

final class DuesInitial extends DuesState {}

final class DuesLoading extends DuesState {}

final class DuesLoaded extends DuesState {
  final List<Due> dues;
  final DuesDashboardModel? dashboardData;

  const DuesLoaded({required this.dues, this.dashboardData});

  @override
  List<Object> get props => [dues, if (dashboardData != null) dashboardData!];
}

final class DuesError extends DuesState {
  final String message;

  const DuesError({required this.message});

  @override
  List<Object> get props => [message];
}

final class DuesActionLoading extends DuesState {}

final class DuesActionSuccess extends DuesState {
  final String message;

  const DuesActionSuccess({required this.message});

  @override
  List<Object> get props => [message];
}
