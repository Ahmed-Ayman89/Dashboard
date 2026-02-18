import '../../../../core/network/api_response.dart';
import '../repositories/admin_repository.dart';

class UpdateAdminUseCase {
  final AdminRepository repository;

  UpdateAdminUseCase(this.repository);

  Future<ApiResponse> call(String id, Map<String, dynamic> data) {
    return repository.updateAdmin(id, data);
  }
}
