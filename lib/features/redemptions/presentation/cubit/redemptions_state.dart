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
  final int total;
  final int page;
  final int limit;

  const RedemptionsLoaded({
    required this.redemptions,
    this.total = 0,
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object> get props => [redemptions, total, page, limit];
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
