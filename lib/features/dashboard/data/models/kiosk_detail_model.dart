class KioskDetailModel {
  final KioskProfile profile;
  final KioskOwnerDetail owner;
  final List<KioskWorker> workers;
  final List<dynamic> topRecipients;
  final KioskDues dues;
  final List<KioskGoal> goals;

  const KioskDetailModel({
    required this.profile,
    required this.owner,
    required this.workers,
    required this.topRecipients,
    required this.dues,
    required this.goals,
  });

  factory KioskDetailModel.fromJson(Map<String, dynamic> json) {
    return KioskDetailModel(
      profile: KioskProfile.fromJson(json['profile']),
      owner: KioskOwnerDetail.fromJson(json['owner']),
      workers: (json['workers'] as List?)
              ?.map((e) => KioskWorker.fromJson(e))
              .toList() ??
          [],
      topRecipients: json['top_recipients'] ?? [],
      dues: KioskDues.fromJson(json['dues']),
      goals: (json['goals'] as List?)
              ?.map((e) => KioskGoal.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class KioskProfile {
  final String id;
  final String name;
  final String? location;
  final String? address;
  final String? kioskType;
  final bool isActive;
  final DateTime createdAt;

  const KioskProfile({
    required this.id,
    required this.name,
    this.location,
    this.address,
    this.kioskType,
    required this.isActive,
    required this.createdAt,
  });

  factory KioskProfile.fromJson(Map<String, dynamic> json) {
    return KioskProfile(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      address: json['address'],
      kioskType: json['kiosk_type'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class KioskOwnerDetail {
  final String id;
  final String fullName;
  final String phone;

  const KioskOwnerDetail({
    required this.id,
    required this.fullName,
    required this.phone,
  });

  factory KioskOwnerDetail.fromJson(Map<String, dynamic> json) {
    return KioskOwnerDetail(
      id: json['id'],
      fullName: json['full_name'],
      phone: json['phone'],
    );
  }
}

class KioskDues {
  final String? id;
  final num? amount;
  final bool isPaid;

  const KioskDues({
    this.id,
    this.amount,
    required this.isPaid,
  });

  factory KioskDues.fromJson(Map<String, dynamic> json) {
    return KioskDues(
      id: json['id'],
      amount:
          json['amount'] != null ? num.tryParse(json['amount'].toString()) : 0,
      isPaid: json['is_paid'] ?? false,
    );
  }
}

class KioskGoal {
  final String id;
  final String title;
  final int target;
  final String status;
  final DateTime? deadline;

  const KioskGoal({
    required this.id,
    required this.title,
    required this.target,
    required this.status,
    this.deadline,
  });

  factory KioskGoal.fromJson(Map<String, dynamic> json) {
    return KioskGoal(
      id: json['id'],
      title: json['title'],
      target: json['target'],
      status: json['status'],
      deadline:
          json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
    );
  }
}

class KioskWorker {
  final String id;
  final String name;
  final String phone;
  final String status;

  const KioskWorker({
    required this.id,
    required this.name,
    required this.phone,
    required this.status,
  });

  factory KioskWorker.fromJson(Map<String, dynamic> json) {
    return KioskWorker(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      status: json['status'],
    );
  }
}
