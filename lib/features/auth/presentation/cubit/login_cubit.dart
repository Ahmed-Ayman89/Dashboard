import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/login_request_model.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit(this._loginUseCase) : super(LoginInitial());

  Future<void> login(String phone, String password) async {
    emit(LoginLoading());

    try {
      final response = await _loginUseCase(
        LoginRequestModel(phone: phone, password: password),
      );

      if (isClosed) return;

      if (response.isSuccess) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure(response.message ?? 'Login failed'));
      }
    } catch (e) {
      if (isClosed) return;
      emit(LoginFailure(e.toString()));
    }
  }
}
