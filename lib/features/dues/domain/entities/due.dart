import 'package:equatable/equatable.dart';

class Due extends Equatable {
  final String id;
  final String kioskId;
  final String amount;
  final bool isPaid;
  final String? collectedBy;
  final String? lastCollectedAt;
  final String createdAt;
  final String updatedAt;
  final String kioskName;
  final String ownerName;

  const Due({
    required this.id,
    required this.kioskId,
    required this.amount,
    required this.isPaid,
    this.collectedBy,
    this.lastCollectedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.kioskName,
    required this.ownerName,
  });

  @override
  List<Object?> get props => [
        id,
        kioskId,
        amount,
        isPaid,
        collectedBy,
        lastCollectedAt,
        createdAt,
        updatedAt,
        kioskName,
        ownerName,
      ];
}
