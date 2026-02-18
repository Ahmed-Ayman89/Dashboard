import 'package:equatable/equatable.dart';
import '../../data/models/admin_activity_model.dart';

abstract class AdminActivitiesState extends Equatable {
  const AdminActivitiesState();

  @override
  List<Object> get props => [];
}

class AdminActivitiesInitial extends AdminActivitiesState {}

class AdminActivitiesLoading extends AdminActivitiesState {}

class AdminActivitiesLoaded extends AdminActivitiesState {
  final List<AdminActivity> activities;
  final int total;
  final int page;
  final int limit;

  const AdminActivitiesLoaded({
    required this.activities,
    required this.total,
    required this.page,
    required this.limit,
  });

  @override
  List<Object> get props => [activities, total, page, limit];
}

class AdminActivitiesFailure extends AdminActivitiesState {
  final String message;

  const AdminActivitiesFailure(this.message);

  @override
  List<Object> get props => [message];
}
