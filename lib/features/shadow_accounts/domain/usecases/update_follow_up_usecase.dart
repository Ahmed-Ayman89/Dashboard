import '../repositories/shadow_account_repository.dart';

class UpdateFollowUpUseCase {
  final ShadowAccountRepository _repository;

  UpdateFollowUpUseCase(this._repository);

  Future<void> call(
      {required String phone, required String lastFollowUp}) async {
    return await _repository.updateLastFollowUp(phone, lastFollowUp);
  }
}
