//

enum WorkerStatus {
  active,
  suspended,
  waiting,
}

class WorkerModel {
  final String id;
  final String phone;
  final String kioskName;
  final String ownerName;
  final WorkerStatus status;
  final double commissionEarned;
  final int transactionsCompleted;

  const WorkerModel({
    required this.id,
    required this.phone,
    required this.kioskName,
    required this.ownerName,
    required this.status,
    required this.commissionEarned,
    required this.transactionsCompleted,
  });
}
