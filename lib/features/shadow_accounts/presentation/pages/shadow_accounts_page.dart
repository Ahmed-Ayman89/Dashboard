import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/shadow_accounts/data/models/shadow_account_model.dart';
import 'package:dashboard_grow/features/shadow_accounts/data/repositories/shadow_account_repository_impl.dart';
import 'package:dashboard_grow/features/shadow_accounts/domain/usecases/get_shadow_accounts_usecase.dart';
import 'package:dashboard_grow/features/shadow_accounts/presentation/cubit/shadow_accounts_cubit.dart';
import 'package:dashboard_grow/features/shadow_accounts/presentation/pages/shadow_account_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ShadowAccountsPage extends StatelessWidget {
  const ShadowAccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShadowAccountsCubit(
        GetShadowAccountsUseCase(ShadowAccountRepositoryImpl()),
      )..getShadowAccounts(),
      child: const _ShadowAccountsView(),
    );
  }
}

class _ShadowAccountsView extends StatelessWidget {
  const _ShadowAccountsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: BlocBuilder<ShadowAccountsCubit, ShadowAccountsState>(
                  builder: (context, state) {
                    if (state is ShadowAccountsLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state is ShadowAccountsFailure) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            state.message,
                            style: AppTextStyle.bodyRegular
                                .copyWith(color: AppColors.error),
                          ),
                        ),
                      );
                    } else if (state is ShadowAccountsLoaded) {
                      if (state.shadowAccounts.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text('No shadow accounts found.'),
                          ),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTable(context, state.shadowAccounts),
                          _buildPagination(context, state),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shadow Accounts', style: AppTextStyle.heading1),
        const SizedBox(height: 8),
        Text('Manage shadow accounts and their balances',
            style: AppTextStyle.bodyMedium),
      ],
    );
  }

  Widget _buildTable(BuildContext context, List<ShadowAccountModel> accounts) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width - 64,
        ),
        child: DataTable(
          showCheckboxColumn: false,
          headingRowColor:
              WidgetStateProperty.all(AppColors.neutral100.withOpacity(0.5)),
          horizontalMargin: 24,
          columnSpacing: 24,
          dividerThickness: 0,
          columns: [
            DataColumn(
                label: Text('Phone',
                    style: AppTextStyle.bodySmall
                        .copyWith(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Balance',
                    style: AppTextStyle.bodySmall
                        .copyWith(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Last Follow Up',
                    style: AppTextStyle.bodySmall
                        .copyWith(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Last Updated',
                    style: AppTextStyle.bodySmall
                        .copyWith(fontWeight: FontWeight.bold))),
          ],
          rows: accounts.map((account) {
            return DataRow(
              onSelectChanged: (selected) {
                if (selected != null && selected) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ShadowAccountDetailsPage(phone: account.phone),
                    ),
                  );
                }
              },
              cells: [
                DataCell(InkWell(
                    onTap: () => _navigateToDetails(context, account.phone),
                    child: SizedBox(
                        width: double.infinity,
                        child: Text(account.phone,
                            style: AppTextStyle.bodyMedium)))),
                DataCell(InkWell(
                    onTap: () => _navigateToDetails(context, account.phone),
                    child: SizedBox(
                        width: double.infinity,
                        child: Text('${account.balance} points',
                            style: AppTextStyle.bodyMedium)))),
                DataCell(InkWell(
                    onTap: () => _navigateToDetails(context, account.phone),
                    child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          account.lastFollowUp != null
                              ? _formatDate(account.lastFollowUp!)
                              : 'None',
                          style: AppTextStyle.bodySmall,
                        )))),
                DataCell(InkWell(
                    onTap: () => _navigateToDetails(context, account.phone),
                    child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          DateFormat('MMM d, yyyy HH:mm')
                              .format(DateTime.parse(account.lastUpdated)),
                          style: AppTextStyle.bodySmall,
                        )))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPagination(BuildContext context, ShadowAccountsLoaded state) {
    final total = int.tryParse(state.total.toString()) ?? 0;
    final limit = int.tryParse(state.limit.toString()) ?? 10;
    final page = int.tryParse(state.page.toString()) ?? 1;
    final totalPages = (total / limit).ceil();

    if (total == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              'Showing ${(page - 1) * limit + 1} to ${page * limit > total ? total : page * limit} of $total shadow accounts',
              style: AppTextStyle.caption,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: page > 1
                    ? () =>
                        context.read<ShadowAccountsCubit>().getShadowAccounts(
                              page: page - 1,
                              limit: limit,
                            )
                    : null,
                icon: const Icon(Icons.chevron_left),
                color: page > 1 ? AppColors.primary : AppColors.neutral100,
              ),
              const SizedBox(width: 8),
              Text('Page $page of ${totalPages > 0 ? totalPages : 1}',
                  style: AppTextStyle.bodySmall),
              const SizedBox(width: 8),
              IconButton(
                onPressed: page < totalPages
                    ? () =>
                        context.read<ShadowAccountsCubit>().getShadowAccounts(
                              page: page + 1,
                              limit: limit,
                            )
                    : null,
                icon: const Icon(Icons.chevron_right),
                color: page < totalPages
                    ? AppColors.primary
                    : AppColors.neutral100,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToDetails(BuildContext context, String phone) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ShadowAccountDetailsPage(phone: phone),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (_) {
      try {
        final date = DateFormat('dd-MM-yyyy').parse(dateStr);
        return DateFormat('MMM d, yyyy').format(date);
      } catch (_) {
        return dateStr;
      }
    }
  }
}
