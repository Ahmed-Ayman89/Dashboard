import '../network/local_data.dart';

class RoleHelper {
  static Future<bool> canTakeActions() async {
    final role = await LocalData.getUserRole();
    return role == 'SUPER_ADMIN' || role == 'EDITOR';
  }

  static Future<bool> canManageAdminTeam() async {
    final role = await LocalData.getUserRole();
    return role == 'SUPER_ADMIN';
  }

  static Future<bool> canViewAdminTeam() async {
    final role = await LocalData.getUserRole();
    return role == 'SUPER_ADMIN';
  }
}
