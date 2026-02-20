import 'package:equatable/equatable.dart';
import 'shadow_account_entity.dart';

class ShadowAccountDetailsEntity extends Equatable {
  final ShadowAccountEntity shadowAccount;
  final List<ShadowAccountTransactionEntity> transactions;

  const ShadowAccountDetailsEntity({
    required this.shadowAccount,
    required this.transactions,
  });

  @override
  List<Object?> get props => [shadowAccount, transactions];
}

class ShadowAccountTransactionEntity extends Equatable {
  final String amountNet;
  final String senderPhone;
  final String senderName;
  final String senderRole;
  final String kioskName;
  final DateTime createdAt;

  const ShadowAccountTransactionEntity({
    required this.amountNet,
    required this.senderPhone,
    required this.senderName,
    required this.senderRole,
    required this.kioskName,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        amountNet,
        senderPhone,
        senderName,
        senderRole,
        kioskName,
        createdAt,
      ];
}
