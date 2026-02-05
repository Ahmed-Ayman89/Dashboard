import '../../../../core/network/api_response.dart';
import '../repositories/redemptions_repository.dart';

class GetRedemptionsUseCase {
  final RedemptionsRepository repository;

  GetRedemptionsUseCase(this.repository);

  Future<ApiResponse> call() async {
    return await repository.getPendingRedemptions();
  }
}
