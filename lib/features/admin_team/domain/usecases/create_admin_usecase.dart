import '../../../../core/network/api_response.dart';
import '../../data/models/admin_model.dart';
import '../repositories/admin_repository.dart';

class CreateAdminUseCase {
  final AdminRepository repository;

  CreateAdminUseCase(this.repository);

  Future<ApiResponse> call(CreateAdminRequest request) {
    return repository.createAdmin(request.toJson());
  }
}
