import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/owner_details_model.dart';
import '../../domain/usecases/get_owner_details_usecase.dart';
import '../../domain/usecases/perform_owner_action_usecase.dart';

part 'owner_details_state.dart';

class OwnerDetailsCubit extends Cubit<OwnerDetailsState> {
  final GetOwnerDetailsUseCase getOwnerDetailsUseCase;
  final PerformOwnerActionUseCase performOwnerActionUseCase;

  OwnerDetailsCubit(this.getOwnerDetailsUseCase, this.performOwnerActionUseCase)
      : super(OwnerDetailsInitial());

  Future<void> getOwnerDetails(String id) async {
    emit(OwnerDetailsLoading());
    final response = await getOwnerDetailsUseCase(id);

    if (response.error == null) {
      final ownerDetails = OwnerDetailsModel.fromJson(response.data['data']);
      emit(OwnerDetailsLoaded(owner: ownerDetails));
    } else {
      emit(OwnerDetailsFailure(message: response.message ?? 'Unknown error'));
    }
  }

  Future<void> performAction({
    required String id,
    required String action,
    required String reason,
  }) async {
    emit(OwnerDetailsLoading());
    final response = await performOwnerActionUseCase(
      id: id,
      action: action,
      reason: reason,
    );

    if (response.error == null) {
      await getOwnerDetails(id);
    } else {
      emit(OwnerDetailsFailure(message: response.message ?? 'Unknown error'));
    }
  }
}
