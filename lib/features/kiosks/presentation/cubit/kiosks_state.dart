import '../../../../core/network/api_response.dart';
import '../../../dashboard/data/models/kiosk_model.dart';

abstract class KiosksState {}

class KiosksInitial extends KiosksState {}

class KiosksLoading extends KiosksState {}

class KiosksSuccess extends KiosksState {
  final List<KioskModel> kiosks;
  final int total;
  final int page;
  final int limit;

  KiosksSuccess({
    required this.kiosks,
    required this.total,
    required this.page,
    required this.limit,
  });
}

class KiosksFailure extends KiosksState {
  final String message;
  final ApiError? error;

  KiosksFailure(this.message, {this.error});
}
