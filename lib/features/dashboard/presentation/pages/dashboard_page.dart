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
import 'package:dashboard_grow/features/dashboard/presentation/pages/admin_team_page.dart';
import 'package:dashboard_grow/features/dashboard/presentation/pages/analytics_page.dart';
import '../widgets/nav_item.dart';
import 'home_view.dart';

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
        title: 'Analytics',
        icon: Icons.bar_chart_rounded,
        destination: const AnalyticsPage()),
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
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      appBar: ResponsiveLayout.isMobile(context)
          ? AppBar(
              title: Text('GROW Admin', style: AppTextStyle.heading3),
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
            )
          : null,
      body: Row(
        children: [
          if (ResponsiveLayout.isDesktop(context))
            _Sidebar(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) => setState(() => _selectedIndex = index),
              navItems: _navItems,
            ),
          Expanded(
            child: _navItems[_selectedIndex].destination,
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final List<NavItem> navItems;

  const _Sidebar({
    required this.selectedIndex,
    required this.onItemSelected,
    required this.navItems,
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
            Text(
              'GROW',
              style: AppTextStyle.heading2.copyWith(
                letterSpacing: 2,
                color: AppColors.brandPrimary,
              ),
            ),
            const SizedBox(height: 8),
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
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.title,
    required this.isActive,
    required this.onTap,
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
          color: isActive ? AppColors.white : AppColors.neutral600,
          size: 22,
        ),
        title: Text(
          title,
          style: AppTextStyle.bodyMedium.copyWith(
            color: isActive ? AppColors.white : AppColors.neutral700,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
