import '../../../../core/network/api_response.dart';
import '../repositories/admin_repository.dart';

class GetAdminActivitiesUseCase {
  final AdminRepository repository;

  GetAdminActivitiesUseCase(this.repository);

  Future<ApiResponse> call(String id, {int page = 1, int limit = 20}) {
    return repository.getAdminActivities(id, page: page, limit: limit);
  }
}
