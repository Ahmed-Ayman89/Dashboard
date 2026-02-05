import '../../../../core/network/api_response.dart';
import '../../../dashboard/data/models/kiosk_detail_model.dart';

abstract class KioskDetailsState {}

class KioskDetailsInitial extends KioskDetailsState {}

class KioskDetailsLoading extends KioskDetailsState {}

class KioskDetailsSuccess extends KioskDetailsState {
  final KioskDetailModel kiosk;

  KioskDetailsSuccess(this.kiosk);
}

class KioskDetailsFailure extends KioskDetailsState {
  final String message;
  final ApiError? error;

  KioskDetailsFailure(this.message, {this.error});
}
