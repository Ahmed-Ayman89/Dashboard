import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/shadow_account_details_entity.dart';
import '../../domain/usecases/get_shadow_account_details_usecase.dart';
import '../../domain/usecases/update_follow_up_usecase.dart';

abstract class ShadowAccountDetailsState extends Equatable {
  const ShadowAccountDetailsState();

  @override
  List<Object?> get props => [];
}

class ShadowAccountDetailsInitial extends ShadowAccountDetailsState {}

class ShadowAccountDetailsLoading extends ShadowAccountDetailsState {}

class ShadowAccountDetailsLoaded extends ShadowAccountDetailsState {
  final ShadowAccountDetailsEntity details;

  const ShadowAccountDetailsLoaded(this.details);

  @override
  List<Object?> get props => [details];
}

class ShadowAccountDetailsFailure extends ShadowAccountDetailsState {
  final String message;

  const ShadowAccountDetailsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ShadowAccountDetailsCubit extends Cubit<ShadowAccountDetailsState> {
  final GetShadowAccountDetailsUseCase getDetailsUseCase;
  final UpdateFollowUpUseCase updateFollowUpUseCase;

  ShadowAccountDetailsCubit(this.getDetailsUseCase, this.updateFollowUpUseCase)
      : super(ShadowAccountDetailsInitial());

  Future<void> getDetails(String phone) async {
    emit(ShadowAccountDetailsLoading());
    try {
      final details = await getDetailsUseCase(phone);
      emit(ShadowAccountDetailsLoaded(details));
    } catch (e) {
      emit(ShadowAccountDetailsFailure(e.toString()));
    }
  }

  Future<void> updateFollowUp(String phone, String lastFollowUp) async {
    try {
      await updateFollowUpUseCase(phone: phone, lastFollowUp: lastFollowUp);
      // Refresh details after update
      await getDetails(phone);
    } catch (e) {
      // We might want a separate state for update failure, but for now reuse failure state
      emit(ShadowAccountDetailsFailure(e.toString()));
    }
  }
}
