import 'package:equatable/equatable.dart';

abstract class AdminTeamState extends Equatable {
  const AdminTeamState();

  @override
  List<Object> get props => [];
}

class AdminTeamInitial extends AdminTeamState {}

class AdminTeamLoading extends AdminTeamState {}

class AdminTeamSuccess extends AdminTeamState {
  final String message;

  const AdminTeamSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class AdminTeamFailure extends AdminTeamState {
  final String message;

  const AdminTeamFailure(this.message);

  @override
  List<Object> get props => [message];
}
