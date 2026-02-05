part of 'owner_details_cubit.dart';

abstract class OwnerDetailsState extends Equatable {
  const OwnerDetailsState();

  @override
  List<Object> get props => [];
}

class OwnerDetailsInitial extends OwnerDetailsState {}

class OwnerDetailsLoading extends OwnerDetailsState {}

class OwnerDetailsLoaded extends OwnerDetailsState {
  final OwnerDetailsModel owner;

  const OwnerDetailsLoaded({required this.owner});

  @override
  List<Object> get props => [owner];
}

class OwnerDetailsFailure extends OwnerDetailsState {
  final String message;

  const OwnerDetailsFailure({required this.message});

  @override
  List<Object> get props => [message];
}
