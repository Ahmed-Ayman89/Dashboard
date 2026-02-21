import 'package:dashboard_grow/core/network/api_helper.dart';
import '../../domain/entities/shadow_account_details_entity.dart';
import '../../domain/repositories/shadow_account_repository.dart';
import '../datasources/shadow_account_remote_data_source.dart';
import '../models/shadow_account_details_model.dart';
import '../models/shadow_account_model.dart';

class ShadowAccountRepositoryImpl implements ShadowAccountRepository {
  final ShadowAccountRemoteDataSource remoteDataSource;

  ShadowAccountRepositoryImpl({ShadowAccountRemoteDataSource? remoteDataSource})
      : remoteDataSource =
            remoteDataSource ?? ShadowAccountRemoteDataSource(APIHelper());

  @override
  Future<Map<String, dynamic>> getShadowAccounts({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    final response = await remoteDataSource.getShadowAccounts(
      page: page,
      limit: limit,
      search: search,
    );

    if (response.isSuccess && response.data != null) {
      final List<dynamic> data = response.data['data'] ?? [];
      final List<ShadowAccountModel> shadowAccounts =
          data.map((json) => ShadowAccountModel.fromJson(json)).toList();

      final pagination = response.data['pagination'] ?? {};

      return {
        'shadowAccounts': shadowAccounts,
        'total': pagination['total'] ?? 0,
        'page': pagination['page'] ?? 1,
        'limit': pagination['limit'] ?? 10,
      };
    } else {
      throw Exception(response.message ?? 'Failed to fetch shadow accounts');
    }
  }

  @override
  Future<ShadowAccountDetailsEntity> getShadowAccountDetails(
      String phone) async {
    final response = await remoteDataSource.getShadowAccountDetails(phone);

    if (response.isSuccess && response.data != null) {
      return ShadowAccountDetailsModel.fromJson(response.data['data']);
    } else {
      throw Exception(
          response.message ?? 'Failed to fetch shadow account details');
    }
  }

  @override
  Future<void> updateLastFollowUp(String phone, String lastFollowUp) async {
    final response =
        await remoteDataSource.updateLastFollowUp(phone, lastFollowUp);

    if (!response.isSuccess) {
      throw Exception(
          response.message ?? 'Failed to update last follow up date');
    }
  }
}
