import 'package:equatable/equatable.dart';
import '../../data/models/owner_graph_model.dart';

abstract class OwnerGraphState extends Equatable {
  const OwnerGraphState();

  @override
  List<Object> get props => [];
}

class OwnerGraphInitial extends OwnerGraphState {}

class OwnerGraphLoading extends OwnerGraphState {}

class OwnerGraphLoaded extends OwnerGraphState {
  final OwnerGraphModel graphData;

  const OwnerGraphLoaded(this.graphData);

  @override
  List<Object> get props => [graphData];
}

class OwnerGraphFailure extends OwnerGraphState {
  final String message;

  const OwnerGraphFailure(this.message);

  @override
  List<Object> get props => [message];
}
