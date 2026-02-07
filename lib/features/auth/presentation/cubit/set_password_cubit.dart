import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/set_password_usecase.dart';
import 'set_password_state.dart';

class SetPasswordCubit extends Cubit<SetPasswordState> {
  final SetPasswordUseCase _useCase;

  SetPasswordCubit(this._useCase) : super(SetPasswordInitial());

  Future<void> setPassword(String password) async {
    emit(SetPasswordLoading());
    try {
      final response = await _useCase(password);
      if (isClosed) return;
      if (response.isSuccess) {
        emit(SetPasswordSuccess(
            response.message ?? 'Password set successfully'));
      } else {
        emit(SetPasswordFailure(response.message ?? 'Failed to set password'));
      }
    } catch (e) {
      if (isClosed) return;
      emit(SetPasswordFailure(e.toString()));
    }
  }
}
