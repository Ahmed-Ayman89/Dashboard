import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase _logoutUseCase;

  LogoutCubit(this._logoutUseCase) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      await _logoutUseCase();
      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutFailure(e.toString()));
    }
  }
}
