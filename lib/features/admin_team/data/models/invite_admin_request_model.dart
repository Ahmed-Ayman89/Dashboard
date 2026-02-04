class InviteAdminRequestModel {
  final String phone;
  final String fullName;
  final String adminRole;

  InviteAdminRequestModel({
    required this.phone,
    required this.fullName,
    required this.adminRole,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'fullName': fullName,
      'adminRole': adminRole,
    };
  }
}
