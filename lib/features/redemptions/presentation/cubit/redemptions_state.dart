part of 'redemptions_cubit.dart';

abstract class RedemptionsState extends Equatable {
  const RedemptionsState();

  @override
  List<Object> get props => [];
}

class RedemptionsInitial extends RedemptionsState {}

class RedemptionsLoading extends RedemptionsState {}

class RedemptionsLoaded extends RedemptionsState {
  final List<RedemptionModel> redemptions;

  const RedemptionsLoaded({required this.redemptions});

  @override
  List<Object> get props => [redemptions];
}

class RedemptionsFailure extends RedemptionsState {
  final String message;

  const RedemptionsFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class RedemptionProcessSuccess extends RedemptionsState {
  final String message;

  const RedemptionProcessSuccess({required this.message});

  @override
  List<Object> get props => [message];
}
