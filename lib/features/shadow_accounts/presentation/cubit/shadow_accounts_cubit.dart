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

  ShadowAccountsCubit(this.getShadowAccountsUseCase)
      : super(ShadowAccountsInitial());

  Future<void> getShadowAccounts({int page = 1, int limit = 10}) async {
    emit(ShadowAccountsLoading());
    try {
      final result = await getShadowAccountsUseCase(page: page, limit: limit);
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
}
