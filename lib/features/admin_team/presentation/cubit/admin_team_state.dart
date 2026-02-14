import 'package:equatable/equatable.dart';
import '../../data/models/admin_model.dart';

abstract class AdminTeamState extends Equatable {
  const AdminTeamState();

  @override
  List<Object> get props => [];
}

class AdminTeamInitial extends AdminTeamState {}

class AdminTeamLoading extends AdminTeamState {}

class AdminTeamLoaded extends AdminTeamState {
  final List<AdminUser> admins;
  final int total;
  final int page;
  final int limit;

  const AdminTeamLoaded({
    required this.admins,
    required this.total,
    required this.page,
    required this.limit,
  });

  @override
  List<Object> get props => [admins, total, page, limit];
}

class AdminTeamFailure extends AdminTeamState {
  final String message;

  const AdminTeamFailure(this.message);

  @override
  List<Object> get props => [message];
}

class AdminTeamActionLoading extends AdminTeamState {}

class AdminTeamActionSuccess extends AdminTeamState {
  final String message;

  const AdminTeamActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}
