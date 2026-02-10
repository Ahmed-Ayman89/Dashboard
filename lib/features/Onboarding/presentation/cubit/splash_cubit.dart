import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/local_data.dart';
import '../../../auth/domain/usecases/verify_token_usecase.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final VerifyTokenUseCase _verifyTokenUseCase;

  SplashCubit(this._verifyTokenUseCase) : super(SplashInitial());

  Future<void> checkAuth() async {
    emit(SplashLoading());
    await Future.delayed(const Duration(seconds: 2)); // Min splash time

    final token = LocalData.accessToken;
    if (token != null && token.isNotEmpty) {
      try {
        final response = await _verifyTokenUseCase();
        if (response.isSuccess) {
          final data = response.data;
          bool isTemp = false;
          if (data != null && data['data'] != null) {
            final authData = data['data'];
            // Check specifically for 'temp' as per user logs/instruction
            final temp = authData['temp'];
            final mustChange = authData['mustChangePassword'];
            final firstLogin = authData['isFirstLogin'];

            if (temp == true ||
                temp == 'true' ||
                mustChange == true ||
                mustChange == 'true' ||
                firstLogin == true ||
                firstLogin == 'true') {
              isTemp = true;
            }
          }

          if (isTemp) {
            emit(SplashTempPassword());
          } else {
            emit(SplashAuthenticated());
          }
        } else {
          // Token invalid or expired
          await LocalData.clear();
          emit(SplashUnauthenticated());
        }
      } catch (e) {
        await LocalData.clear();
        emit(SplashUnauthenticated());
      }
    } else {
      emit(SplashUnauthenticated());
    }
  }
}
