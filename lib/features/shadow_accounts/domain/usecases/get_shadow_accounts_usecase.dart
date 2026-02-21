import '../repositories/shadow_account_repository.dart';

class GetShadowAccountsUseCase {
  final ShadowAccountRepository _repository;

  GetShadowAccountsUseCase(this._repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    return await _repository.getShadowAccounts(
      page: page,
      limit: limit,
      search: search,
    );
  }
}
