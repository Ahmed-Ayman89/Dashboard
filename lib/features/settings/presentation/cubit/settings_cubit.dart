import 'package:bloc/bloc.dart';
import 'package:dashboard_grow/features/settings/domain/entities/settings.dart';
import 'package:dashboard_grow/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:dashboard_grow/features/settings/domain/usecases/update_settings_usecase.dart';
import 'package:equatable/equatable.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetSettingsUseCase getSettingsUseCase;
  final UpdateSettingsUseCase updateSettingsUseCase;

  SettingsCubit({
    required this.getSettingsUseCase,
    required this.updateSettingsUseCase,
  }) : super(SettingsInitial());

  Future<void> getSettings() async {
    emit(SettingsLoading());
    final result = await getSettingsUseCase();
    if (isClosed) return;
    result.fold(
      (failure) => emit(SettingsError(message: failure.message)),
      (settings) => emit(SettingsLoaded(settings: settings)),
    );
  }

  Future<void> updateSetting(
      String key, dynamic value, String description) async {
    emit(SettingsActionLoading());
    final result = await updateSettingsUseCase(key, value, description);
    if (isClosed) return;
    result.fold(
      (failure) => emit(SettingsError(message: failure.message)),
      (success) {
        emit(SettingsActionSuccess(message: success));
        getSettings();
      },
    );
  }
}
