import 'package:dartz/dartz.dart';
import 'package:dashboard_grow/core/error/failures.dart';
import 'package:dashboard_grow/features/settings/domain/repositories/settings_repository.dart';

class UpdateSettingsUseCase {
  final SettingsRepository repository;

  UpdateSettingsUseCase({required this.repository});

  Future<Either<Failure, String>> call(
      String key, dynamic value, String description) async {
    return await repository.updateSettings(key, value, description);
  }
}
