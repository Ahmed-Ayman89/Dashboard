import 'package:dartz/dartz.dart';
import 'package:dashboard_grow/core/error/failures.dart';
import 'package:dashboard_grow/features/settings/domain/entities/settings.dart';
import 'package:dashboard_grow/features/settings/domain/repositories/settings_repository.dart';

class GetSettingsUseCase {
  final SettingsRepository repository;

  GetSettingsUseCase({required this.repository});

  Future<Either<Failure, Settings>> call() async {
    return await repository.getSettings();
  }
}
