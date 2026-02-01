//

class KioskModel {
  final String id;
  final String name;
  final String location;
  final String ownerName;
  final double dues;
  final int dailyTransactions;
  final bool isSuspended;

  const KioskModel({
    required this.id,
    required this.name,
    required this.location,
    required this.ownerName,
    required this.dues,
    required this.dailyTransactions,
    this.isSuspended = false,
  });
}
