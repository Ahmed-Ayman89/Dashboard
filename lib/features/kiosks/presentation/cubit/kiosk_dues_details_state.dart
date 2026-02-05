part of 'kiosk_dues_details_cubit.dart';

abstract class KioskDuesDetailsState extends Equatable {
  const KioskDuesDetailsState();

  @override
  List<Object> get props => [];
}

class KioskDuesDetailsInitial extends KioskDuesDetailsState {}

class KioskDuesDetailsLoading extends KioskDuesDetailsState {}

class KioskDuesDetailsSuccess extends KioskDuesDetailsState {
  final KioskDuesDetailsModel details;

  const KioskDuesDetailsSuccess(this.details);

  @override
  List<Object> get props => [details];
}

class KioskDuesDetailsFailure extends KioskDuesDetailsState {
  final String message;

  const KioskDuesDetailsFailure(this.message);

  @override
  List<Object> get props => [message];
}
