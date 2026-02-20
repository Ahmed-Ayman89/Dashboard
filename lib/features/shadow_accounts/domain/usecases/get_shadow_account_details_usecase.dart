import '../entities/shadow_account_details_entity.dart';
import '../repositories/shadow_account_repository.dart';

class GetShadowAccountDetailsUseCase {
  final ShadowAccountRepository _repository;

  GetShadowAccountDetailsUseCase(this._repository);

  Future<ShadowAccountDetailsEntity> call(String phone) async {
    return await _repository.getShadowAccountDetails(phone);
  }
}
