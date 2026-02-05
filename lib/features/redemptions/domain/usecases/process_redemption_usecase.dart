import '../../../../core/network/api_response.dart';
import '../repositories/redemptions_repository.dart';

class ProcessRedemptionUseCase {
  final RedemptionsRepository repository;

  ProcessRedemptionUseCase(this.repository);

  Future<ApiResponse> call(
      {required String id,
      required String action,
      required String note}) async {
    return await repository.processRedemption(id, action, note);
  }
}
