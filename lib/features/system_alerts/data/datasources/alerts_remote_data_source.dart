import 'package:dashboard_grow/core/network/api_endpoiont.dart';
import 'package:dashboard_grow/core/network/api_helper.dart';
import 'package:dashboard_grow/features/system_alerts/data/models/system_alert_model.dart';

abstract class AlertsRemoteDataSource {
  Future<SystemAlertResponse> getSystemAlerts({int page = 1, int limit = 10});
}

class AlertsRemoteDataSourceImpl implements AlertsRemoteDataSource {
  final APIHelper apiHelper;

  AlertsRemoteDataSourceImpl({required this.apiHelper});

  @override
  Future<SystemAlertResponse> getSystemAlerts(
      {int page = 1, int limit = 10}) async {
    final response = await apiHelper.getRequest(
      endPoint: EndPoints.systemAlerts,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    return SystemAlertResponse.fromJson(response.data);
  }
}
