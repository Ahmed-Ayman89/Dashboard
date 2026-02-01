enum RedemptionStatus {
  pending,
  approved,
  rejected,
}

enum UserType {
  owner,
  worker,
  customer,
}

class RedemptionModel {
  final String id;
  final UserType userType;
  final String userName;
  final double amount;
  final String paymentMethod;
  final String paymentDetails;
  final DateTime requestedAt;
  final RedemptionStatus status;

  const RedemptionModel({
    required this.id,
    required this.userType,
    required this.userName,
    required this.amount,
    required this.paymentMethod,
    required this.paymentDetails,
    required this.requestedAt,
    required this.status,
  });
}
