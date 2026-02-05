import '../../data/models/audit_log_model.dart';
import '../../../../core/network/api_response.dart';

abstract class AuditLogsState {}

class AuditLogsInitial extends AuditLogsState {}

class AuditLogsLoading extends AuditLogsState {}

class AuditLogsSuccess extends AuditLogsState {
  final List<AuditLogModel> logs;
  final int total;
  final int page;
  final int limit;

  AuditLogsSuccess({
    required this.logs,
    required this.total,
    required this.page,
    required this.limit,
  });
}

class AuditLogsFailure extends AuditLogsState {
  final String message;
  final ApiError? error;

  AuditLogsFailure(this.message, {this.error});
}
