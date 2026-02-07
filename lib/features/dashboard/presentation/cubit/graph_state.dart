import 'package:equatable/equatable.dart';
import '../../domain/entities/graph_entity.dart';

abstract class GraphState extends Equatable {
  const GraphState();

  @override
  List<Object?> get props => [];
}

class GraphInitial extends GraphState {}

class GraphLoading extends GraphState {}

class GraphSuccess extends GraphState {
  final GraphEntity graphData;

  const GraphSuccess(this.graphData);

  @override
  List<Object?> get props => [graphData];
}

class GraphError extends GraphState {
  final String message;

  const GraphError(this.message);

  @override
  List<Object?> get props => [message];
}
