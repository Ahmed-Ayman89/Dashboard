import 'package:dashboard_grow/core/services/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/login_request_model.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/verify_token_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  final VerifyTokenUseCase _verifyTokenUseCase;

  LoginCubit(this._loginUseCase, this._verifyTokenUseCase)
      : super(LoginInitial());

  Future<void> login(String phone, String password) async {
    emit(LoginLoading());

    try {
      final response = await _loginUseCase(
        LoginRequestModel(
          phone: phone,
          password: password,
        ),
      );

      if (isClosed) return;

      if (response.isSuccess) {
        // Verify token to check for tempAuth/mustChangePassword
        try {
          final verifyResponse = await _verifyTokenUseCase();
          bool mustChangePassword = false;

          if (verifyResponse.isSuccess && verifyResponse.data != null) {
            final data = verifyResponse.data;
            if (data is Map<String, dynamic> && data['data'] != null) {
              final authData = data['data'];
              final temp = authData[
                  'temp']; // Use 'temp' (from response) or 'isTemp' based on API.
              final mustChange = authData['mustChangePassword'];
              final isFirstLogin = authData['isFirstLogin'];

              if (temp == true ||
                  temp == 'true' ||
                  mustChange == true ||
                  mustChange == 'true' ||
                  isFirstLogin == true ||
                  isFirstLogin == 'true') {
                mustChangePassword = true;
              }
            }
          }

          // Sync FCM Token (only on mobile platforms)
          if (!kIsWeb &&
              (defaultTargetPlatform == TargetPlatform.android ||
                  defaultTargetPlatform == TargetPlatform.iOS)) {
            try {
              await NotificationService.instance.syncCurrentToken();
            } catch (e) {
              // Don't fail login if FCM sync fails
              print('FCM token sync failed: $e');
            }
          }

          emit(LoginSuccess(mustChangePassword: mustChangePassword));
        } catch (e) {
          emit(LoginFailure("Authentication verification failed: $e"));
        }
      } else {
        emit(LoginFailure(response.message ?? 'Login failed'));
      }
    } catch (e) {
      if (isClosed) return;
      emit(LoginFailure(e.toString()));
    }
  }
}
