import 'package:equatable/equatable.dart';
import '../../data/models/worker_graph_model.dart';

abstract class WorkerGraphState extends Equatable {
  const WorkerGraphState();

  @override
  List<Object> get props => [];
}

class WorkerGraphInitial extends WorkerGraphState {}

class WorkerGraphLoading extends WorkerGraphState {}

class WorkerGraphLoaded extends WorkerGraphState {
  final WorkerGraphModel graphData;

  const WorkerGraphLoaded(this.graphData);

  @override
  List<Object> get props => [graphData];
}

class WorkerGraphFailure extends WorkerGraphState {
  final String message;

  const WorkerGraphFailure(this.message);

  @override
  List<Object> get props => [message];
}
