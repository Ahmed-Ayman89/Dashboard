import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard_grow/core/services/notification_service.dart';
import 'package:dashboard_grow/core/network/local_data.dart';
import '../../domain/usecases/delete_fcm_token_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase _logoutUseCase;
  final DeleteFcmTokenUseCase _deleteFcmTokenUseCase;

  LogoutCubit(this._logoutUseCase, this._deleteFcmTokenUseCase)
      : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      if (kDebugMode) {
        print("LogoutCubit: Starting logout process...");
      }

      // Try to get token from Firebase SDK
      String? token = await NotificationService.instance.getToken();

      // If failed, try to get from local storage
      if (token == null) {
        if (kDebugMode) {
          print(
              "LogoutCubit: NotificationService returned null, trying LocalData...");
        }
        token = await LocalData.getRegistrationToken();
      }

      if (kDebugMode) {
        print("LogoutCubit: FCM Token: $token");
      }

      if (token != null) {
        if (kDebugMode) {
          print("LogoutCubit: Calling deleteFcmToken endpoint...");
        }
        final response = await _deleteFcmTokenUseCase(token);
        if (kDebugMode) {
          print(
              "LogoutCubit: deleteFcmToken response: ${response.isSuccess} - ${response.message}");
        }
      } else {
        if (kDebugMode) {
          print("LogoutCubit: FCM token is null, skipping deletion call.");
        }
      }

      await _logoutUseCase();
      if (kDebugMode) {
        print("LogoutCubit: Local logout completed.");
      }

      if (isClosed) return;
      emit(LogoutSuccess());
    } catch (e) {
      if (kDebugMode) {
        print("LogoutCubit: Error during logout: $e");
      }
      if (isClosed) return;
      emit(LogoutFailure(e.toString()));
    }
  }
}
