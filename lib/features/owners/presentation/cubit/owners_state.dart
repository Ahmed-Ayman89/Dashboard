part of 'owners_cubit.dart';

abstract class OwnersState extends Equatable {
  const OwnersState();

  @override
  List<Object> get props => [];
}

class OwnersInitial extends OwnersState {}

class OwnersLoading extends OwnersState {}

class OwnersLoaded extends OwnersState {
  final List<OwnerModel> owners;
  final int total;
  final int page;
  final bool hasReachedMax;
  final bool isFetchingMore;

  const OwnersLoaded({
    required this.owners,
    required this.total,
    required this.page,
    required this.hasReachedMax,
    this.isFetchingMore = false,
  });

  @override
  List<Object> get props =>
      [owners, total, page, hasReachedMax, isFetchingMore];
}

class OwnersFailure extends OwnersState {
  final String message;

  const OwnersFailure({required this.message});

  @override
  List<Object> get props => [message];
}
