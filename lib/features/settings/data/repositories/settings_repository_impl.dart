import 'package:dartz/dartz.dart';
import 'package:dashboard_grow/core/error/failures.dart';
import 'package:dashboard_grow/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:dashboard_grow/features/settings/domain/entities/settings.dart';
import 'package:dashboard_grow/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;

  SettingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Settings>> getSettings() async {
    try {
      final settings = await remoteDataSource.getSettings();
      return Right(settings);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updateSettings(
      String key, dynamic value, String description) async {
    try {
      await remoteDataSource.updateSettings(key, value, description);
      return const Right('Settings updated successfully');
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
