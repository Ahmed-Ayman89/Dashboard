import 'package:equatable/equatable.dart';
import '../../data/models/kiosk_graph_model.dart';

abstract class KioskGraphState extends Equatable {
  const KioskGraphState();

  @override
  List<Object> get props => [];
}

class KioskGraphInitial extends KioskGraphState {}

class KioskGraphLoading extends KioskGraphState {}

class KioskGraphLoaded extends KioskGraphState {
  final KioskGraphModel graphData;

  const KioskGraphLoaded(this.graphData);

  @override
  List<Object> get props => [graphData];
}

class KioskGraphFailure extends KioskGraphState {
  final String message;

  const KioskGraphFailure(this.message);

  @override
  List<Object> get props => [message];
}
