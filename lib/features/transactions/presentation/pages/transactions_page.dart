import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/transactions/data/repositories/transactions_repository_impl.dart';
import 'package:dashboard_grow/features/transactions/domain/usecases/get_transactions_usecase.dart';
import 'package:dashboard_grow/features/transactions/presentation/cubit/transactions_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionsCubit(
        GetTransactionsUseCase(TransactionsRepositoryImpl()),
      )..getTransactions(),
      child: const _TransactionsView(),
    );
  }
}

class _TransactionsView extends StatefulWidget {
  const _TransactionsView();

  @override
  State<_TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<_TransactionsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<TransactionsCubit>().getTransactions();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.neutral200),
                ),
                child: BlocBuilder<TransactionsCubit, TransactionsState>(
                  builder: (context, state) {
                    if (state is TransactionsLoading &&
                        (state is! TransactionsLoaded)) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TransactionsFailure) {
                      return Center(
                        child: Text(state.message,
                            style: AppTextStyle.bodyRegular
                                .copyWith(color: AppColors.error)),
                      );
                    } else if (state is TransactionsLoaded) {
                      return _buildPaginatedList(state);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Transactions', style: AppTextStyle.heading2),
        // Add Filters or Search if needed later
      ],
    );
  }

  Widget _buildPaginatedList(TransactionsLoaded state) {
    if (state.transactions.isEmpty) {
      return Center(
          child: Text('No transactions found',
              style: AppTextStyle.bodyRegular
                  .copyWith(color: AppColors.neutral500)));
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: AppColors.neutral200,
                  dataTableTheme: DataTableThemeData(
                    headingRowColor: WidgetStateProperty.all(AppColors.border),
                    dataRowColor: WidgetStateProperty.all(AppColors.white),
                  ),
                ),
                child: DataTable(
                  columns: [
                    DataColumn(
                        label: Text('Date', style: AppTextStyle.caption)),
                    DataColumn(label: Text('ID', style: AppTextStyle.caption)),
                    DataColumn(
                        label: Text('Type', style: AppTextStyle.caption)),
                    DataColumn(
                        label: Text('Amount (Gross)',
                            style: AppTextStyle.caption)),
                    DataColumn(
                        label: Text('Commission', style: AppTextStyle.caption)),
                    DataColumn(
                        label:
                            Text('Amount (Net)', style: AppTextStyle.caption)),
                    DataColumn(
                        label: Text('Status', style: AppTextStyle.caption)),
                    DataColumn(
                        label: Text('Kiosk', style: AppTextStyle.caption)),
                    DataColumn(
                        label: Text('Owner', style: AppTextStyle.caption)),
                    DataColumn(
                        label: Text('Worker', style: AppTextStyle.caption)),
                    DataColumn(
                        label: Text('Customer', style: AppTextStyle.caption)),
                  ],
                  rows: state.transactions.map((transaction) {
                    return DataRow(cells: [
                      DataCell(Text(
                          DateFormat('MMM d, yyyy HH:mm')
                              .format(transaction.timestamp),
                          style: AppTextStyle.bodySmall)),
                      DataCell(Text(
                          transaction.id.substring(0, 8), // Shorten ID
                          style: AppTextStyle.bodySmall
                              .copyWith(fontFamily: 'monospace'))),
                      DataCell(_buildTypeBadge(transaction.type)),
                      DataCell(Text(
                          '${transaction.amountGross.toStringAsFixed(2)} EGP',
                          style: AppTextStyle.bodySmall)),
                      DataCell(Text(
                          '${transaction.commission.toStringAsFixed(2)} EGP',
                          style: AppTextStyle.bodySmall)),
                      DataCell(Text(
                          '${transaction.amountNet.toStringAsFixed(2)} EGP',
                          style: AppTextStyle.bodySmall)),
                      DataCell(_buildStatusBadge(transaction.status)),
                      DataCell(Text(transaction.kiosk,
                          style: AppTextStyle.bodySmall)),
                      DataCell(Text(transaction.owner,
                          style: AppTextStyle.bodySmall)),
                      DataCell(Text(transaction.worker,
                          style: AppTextStyle.bodySmall)),
                      DataCell(Text(transaction.customer,
                          style: AppTextStyle.bodySmall)),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
        if (state.isFetchingMore)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color fg;
    String label = status;

    switch (status.toUpperCase()) {
      case 'COMPLETED':
      case 'SUCCESS':
        bg = AppColors.success.withOpacity(0.1);
        fg = AppColors.success;
        break;
      case 'PENDING':
        bg = AppColors.warning.withOpacity(0.1);
        fg = AppColors.warning;
        break;
      case 'FAILED':
      case 'REJECTED':
        bg = AppColors.error.withOpacity(0.1);
        fg = AppColors.error;
        break;
      default:
        bg = AppColors.neutral100;
        fg = AppColors.neutral600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyle.caption.copyWith(
          color: fg,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTypeBadge(String type) {
    Color color;
    IconData icon;

    if (type.toUpperCase() == 'DEPOSIT') {
      color = AppColors.success;
      icon = Icons.arrow_downward;
    } else if (type.toUpperCase() == 'WITHDRAWAL') {
      color = AppColors.error;
      icon = Icons.arrow_upward;
    } else {
      color = AppColors.neutral600;
      icon = Icons.swap_horiz;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          type,
          style: AppTextStyle.bodySmall
              .copyWith(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
