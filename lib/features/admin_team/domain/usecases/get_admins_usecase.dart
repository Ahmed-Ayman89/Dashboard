import '../../../../core/network/api_response.dart';
import '../repositories/admin_repository.dart';

class GetAdminsUseCase {
  final AdminRepository repository;

  GetAdminsUseCase(this.repository);

  Future<ApiResponse> call({int page = 1, int limit = 10}) {
    return repository.getAdmins(page: page, limit: limit);
  }
}
