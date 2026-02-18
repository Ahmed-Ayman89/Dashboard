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
        final List<dynamic> logsJson = response.data['data'] ?? [];
        final logs =
            logsJson.map((json) => AuditLogModel.fromJson(json)).toList();

        final pagination = response.data['pagination'];
        final total = pagination != null ? pagination['total'] : logs.length;
        final currentPage = pagination != null ? pagination['page'] : 1;
        final currentLimit = pagination != null ? pagination['limit'] : 20;

        emit(AuditLogsSuccess(
          logs: logs,
          total: total ?? 0,
          page: currentPage ?? 1,
          limit: currentLimit ?? 20,
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

  Future<void> changePage(int page) async {
    await getLogs(page: page);
  }
}
