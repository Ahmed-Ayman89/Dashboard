import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/shadow_account_model.dart';
import '../../domain/usecases/get_shadow_accounts_usecase.dart';

abstract class ShadowAccountsState extends Equatable {
  const ShadowAccountsState();

  @override
  List<Object?> get props => [];
}

class ShadowAccountsInitial extends ShadowAccountsState {}

class ShadowAccountsLoading extends ShadowAccountsState {}

class ShadowAccountsLoaded extends ShadowAccountsState {
  final List<ShadowAccountModel> shadowAccounts;
  final int total;
  final int page;
  final int limit;

  const ShadowAccountsLoaded({
    required this.shadowAccounts,
    required this.total,
    required this.page,
    required this.limit,
  });

  @override
  List<Object?> get props => [shadowAccounts, total, page, limit];
}

class ShadowAccountsFailure extends ShadowAccountsState {
  final String message;

  const ShadowAccountsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ShadowAccountsCubit extends Cubit<ShadowAccountsState> {
  final GetShadowAccountsUseCase getShadowAccountsUseCase;
  String? _searchQuery;

  ShadowAccountsCubit(this.getShadowAccountsUseCase)
      : super(ShadowAccountsInitial());

  Future<void> getShadowAccounts({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    // If search is provided (even if empty string), we update it.
    // If search is null (typical for pagination call), we preserve existing.
    if (search != null) {
      _searchQuery = search;
    }

    emit(ShadowAccountsLoading());
    try {
      final result = await getShadowAccountsUseCase(
        page: page,
        limit: limit,
        search: _searchQuery,
      );
      emit(ShadowAccountsLoaded(
        shadowAccounts: result['shadowAccounts'],
        total: result['total'],
        page: result['page'],
        limit: result['limit'],
      ));
    } catch (e) {
      emit(ShadowAccountsFailure(e.toString()));
    }
  }

  void searchShadowAccounts(String query) {
    if (query == _searchQuery) return;
    getShadowAccounts(page: 1, search: query);
  }
}
