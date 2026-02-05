import 'package:equatable/equatable.dart';
import '../../data/models/worker_model.dart';

abstract class WorkersState extends Equatable {
  const WorkersState();

  @override
  List<Object> get props => [];
}

class WorkersInitial extends WorkersState {}

class WorkersLoading extends WorkersState {}

class WorkersLoaded extends WorkersState {
  final List<WorkerModel> workers;
  final int total;
  final int page;
  final int limit;

  const WorkersLoaded({
    required this.workers,
    required this.total,
    required this.page,
    required this.limit,
  });

  @override
  List<Object> get props => [workers, total, page, limit];
}

class WorkersFailure extends WorkersState {
  final String message;

  const WorkersFailure(this.message);

  @override
  List<Object> get props => [message];
}
