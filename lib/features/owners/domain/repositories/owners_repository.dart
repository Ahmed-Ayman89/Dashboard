import '../../../../core/network/api_response.dart';

abstract class OwnersRepository {
  Future<ApiResponse> getOwners({
    int page = 1,
    int limit = 10,
    String search = '',
  });

  Future<ApiResponse> getOwnerDetails(String id);

  Future<ApiResponse> performAction({
    required String id,
    required String action,
    required String reason,
  });
}
