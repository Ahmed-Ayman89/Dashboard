import 'package:equatable/equatable.dart';

class ShadowAccountEntity extends Equatable {
  final String phone;
  final String balance;
  final String? lastFollowUp;
  final String lastUpdated;

  const ShadowAccountEntity({
    required this.phone,
    required this.balance,
    this.lastFollowUp,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [phone, balance, lastFollowUp, lastUpdated];
}
