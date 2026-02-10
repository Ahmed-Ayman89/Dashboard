import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/core/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:dashboard_grow/features/owners/presentation/pages/owners_page.dart';
import 'package:dashboard_grow/features/kiosks/presentation/pages/kiosks_page.dart';
import 'package:dashboard_grow/features/workers/presentation/pages/workers_page.dart';
import 'package:dashboard_grow/features/customers/presentation/pages/customers_page.dart';
import 'package:dashboard_grow/features/transactions/presentation/pages/transactions_page.dart';
import 'package:dashboard_grow/features/redemptions/presentation/pages/redemptions_page.dart';
import 'package:dashboard_grow/features/dues/presentation/pages/dues_page.dart';
import 'package:dashboard_grow/features/settings/presentation/pages/settings_page.dart';
import 'package:dashboard_grow/features/dashboard/presentation/pages/audit_log_page.dart';
import 'package:dashboard_grow/features/calls/presentation/pages/calls_page.dart';
import 'package:dashboard_grow/features/admin_team/presentation/pages/admin_team_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/nav_item.dart';
import 'home_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/usecases/logout_usecase.dart';
import '../../../auth/presentation/cubit/logout_cubit.dart';
import '../../../auth/presentation/cubit/logout_state.dart';
import '../../../Onboarding/onboarding_screen.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<NavItem> _navItems = [
    NavItem(
        title: 'Home', icon: Icons.home_rounded, destination: const HomeView()),
    NavItem(
        title: 'Admin Team',
        icon: Icons.admin_panel_settings_rounded,
        destination: const AdminTeamPage()),
    NavItem(
        title: 'Owners',
        icon: Icons.person_pin_rounded,
        destination: const OwnersPage()),
    NavItem(
        title: 'Kiosks',
        icon: Icons.store_rounded,
        destination: const KiosksPage()),
    NavItem(
        title: 'Workers',
        icon: Icons.engineering_rounded,
        destination: const WorkersPage()),
    NavItem(
        title: 'Customers',
        icon: Icons.people_rounded,
        destination: const CustomersPage()),
    NavItem(
        title: 'Transactions',
        icon: Icons.receipt_long_rounded,
        destination: const TransactionsPage()),
    NavItem(
        title: 'Redemptions',
        icon: Icons.redeem_rounded,
        destination: const RedemptionsPage()),
    NavItem(
        title: 'Dues',
        icon: Icons.account_balance_wallet_rounded,
        destination: const DuesPage()),
    NavItem(
        title: 'Calls',
        icon: Icons.call_rounded,
        destination: const CallsPage()),
    NavItem(
        title: 'Settings',
        icon: Icons.settings_rounded,
        destination: const SettingsPage()),
    NavItem(
        title: 'Audit Log',
        icon: Icons.history_rounded,
        destination: const AuditLogPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogoutCubit(
        LogoutUseCase(AuthRepositoryImpl()),
      ),
      child: BlocListener<LogoutCubit, LogoutState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const OnboardingScreen(),
              ),
              (route) => false,
            );
          } else if (state is LogoutFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Builder(builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.neutral100,
            appBar: ResponsiveLayout.isMobile(context)
                ? AppBar(
                    title: SvgPicture.asset('assets/onboarding/glow.svg',
                        height: 28),
                    backgroundColor: AppColors.white,
                    elevation: 0,
                  )
                : null,
            drawer: ResponsiveLayout.isMobile(context)
                ? _Sidebar(
                    selectedIndex: _selectedIndex,
                    onItemSelected: (index) {
                      setState(() => _selectedIndex = index);
                      Navigator.pop(context);
                    },
                    navItems: _navItems,
                    onLogout: () {
                      context.read<LogoutCubit>().logout();
                    },
                  )
                : null,
            body: Row(
              children: [
                if (ResponsiveLayout.isDesktop(context))
                  _Sidebar(
                    selectedIndex: _selectedIndex,
                    onItemSelected: (index) =>
                        setState(() => _selectedIndex = index),
                    navItems: _navItems,
                    onLogout: () {
                      context.read<LogoutCubit>().logout();
                    },
                  ),
                Expanded(
                  child: _navItems[_selectedIndex].destination,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final List<NavItem> navItems;
  final VoidCallback onLogout;

  const _Sidebar({
    required this.selectedIndex,
    required this.onItemSelected,
    required this.navItems,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: AppColors.white,
      child: Column(
        children: [
          if (ResponsiveLayout.isDesktop(context)) ...[
            const SizedBox(height: 48),
            SvgPicture.asset(
              'assets/onboarding/glow.svg',
              height: 50,
            ),
            const SizedBox(height: 16),
            Text(
              'ADMIN DASHBOARD',
              style: AppTextStyle.caption.copyWith(
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 48),
          ] else ...[
            const SizedBox(height: 24),
          ],
          Expanded(
            child: ListView.builder(
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isActive = selectedIndex == index;
                return _SidebarItem(
                  icon: item.icon,
                  title: item.title,
                  isActive: isActive,
                  onTap: () => onItemSelected(index),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: _SidebarItem(
              color: AppColors.red,
              icon: Icons.logout_rounded,
              title: 'Logout',
              isActive: false,
              isDestructive: true,
              onTap: onLogout,
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final bool isDestructive;
  final VoidCallback onTap;
  final Color? color;

  const _SidebarItem({
    required this.icon,
    required this.title,
    required this.isActive,
    this.isDestructive = false,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.brandPrimary : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.brandPrimary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(
          icon,
          color: isActive
              ? AppColors.white
              : (isDestructive ? AppColors.red : AppColors.neutral600),
          size: 24.sp,
        ),
        title: Text(
          title,
          style: AppTextStyle.bodyMedium.copyWith(
            color: isActive
                ? AppColors.white
                : (isDestructive ? AppColors.red : AppColors.neutral700),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
