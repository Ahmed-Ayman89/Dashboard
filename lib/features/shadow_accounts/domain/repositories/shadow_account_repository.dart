import '../entities/shadow_account_details_entity.dart';

abstract class ShadowAccountRepository {
  Future<Map<String, dynamic>> getShadowAccounts(
      {int page = 1, int limit = 10});
  Future<ShadowAccountDetailsEntity> getShadowAccountDetails(String phone);
  Future<void> updateLastFollowUp(String phone, String lastFollowUp);
}
