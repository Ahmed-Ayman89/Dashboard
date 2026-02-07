import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_audit_logs_usecase.dart';
import 'audit_logs_state.dart';
import '../../data/models/audit_log_model.dart';

class AuditLogsCubit extends Cubit<AuditLogsState> {
  final GetAuditLogsUseCase _getAuditLogsUseCase;

  AuditLogsCubit(this._getAuditLogsUseCase) : super(AuditLogsInitial());

  Future<void> getLogs({int page = 1, int limit = 20}) async {
    emit(AuditLogsLoading());
    try {
      final response = await _getAuditLogsUseCase(page: page, limit: limit);

      if (isClosed) return;

      if (response.isSuccess) {
        final data = response.data['data'];
        final List<dynamic> logsJson = data['logs'];
        final logs =
            logsJson.map((json) => AuditLogModel.fromJson(json)).toList();
        final total = data['total'];
        final currentPage = data['page'];
        final currentLimit = data['limit'];

        emit(AuditLogsSuccess(
          logs: logs,
          total: total,
          page: currentPage,
          limit: currentLimit,
        ));
      } else {
        emit(AuditLogsFailure(response.message ?? 'Failed to fetch audit logs',
            error: response.error));
      }
    } catch (e) {
      if (isClosed) return;
      emit(AuditLogsFailure(e.toString()));
    }
  }
}
