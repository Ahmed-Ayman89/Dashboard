import 'package:dashboard_grow/core/helper/app_text_style.dart';
import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:dashboard_grow/features/customers/data/repositories/customers_repository_impl.dart';
import 'package:dashboard_grow/features/customers/domain/usecases/get_customers_usecase.dart';
import 'package:dashboard_grow/features/customers/presentation/cubit/customers_cubit.dart';
import 'package:dashboard_grow/features/customers/presentation/pages/customer_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repository = CustomersRepositoryImpl();
        return CustomersCubit(GetCustomersUseCase(repository))..getCustomers();
      },
      child: const _CustomersView(),
    );
  }
}

class _CustomersView extends StatefulWidget {
  const _CustomersView();

  @override
  State<_CustomersView> createState() => _CustomersViewState();
}

class _CustomersViewState extends State<_CustomersView> {
  final TextEditingController _searchController = TextEditingController();

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
              Text('Customer Management', style: AppTextStyle.heading1),
              const SizedBox(height: 32),
              _buildFilters(context),
              const SizedBox(height: 24),
              _buildCustomersTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: TextField(
        controller: _searchController,
        onSubmitted: (value) {
          context.read<CustomersCubit>().searchCustomers(value);
        },
        decoration: InputDecoration(
          hintText: 'Search customers by name or phone...',
          hintStyle: AppTextStyle.bodySmall,
          border: InputBorder.none,
          icon: const Icon(Icons.search_rounded, color: AppColors.neutral500),
          suffixIcon: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _searchController.clear();
              context.read<CustomersCubit>().getCustomers();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCustomersTable() {
    return BlocBuilder<CustomersCubit, CustomersState>(
      builder: (context, state) {
        if (state is CustomersLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CustomersFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message,
                    style: AppTextStyle.bodyRegular
                        .copyWith(color: AppColors.error)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      context.read<CustomersCubit>().getCustomers(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (state is CustomersLoaded) {
          if (state.customers.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No customers found'),
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width - 64,
                        ),
                        child: DataTable(
                          showCheckboxColumn: false,
                          headingRowColor:
                              WidgetStateProperty.all(AppColors.neutral100),
                          columns: const [
                            DataColumn(label: Text('Customer Info')),
                            DataColumn(label: Text('Balance')),
                            DataColumn(label: Text('Points')),
                            DataColumn(label: Text('Interactions')),
                            DataColumn(label: Text('App Status')),
                            DataColumn(label: Text('Joined Date')),
                          ],
                          rows: state.customers.map((customer) {
                            return DataRow(
                              onSelectChanged: (selected) {
                                if (selected == true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CustomerDetailsPage(
                                          customerId: customer.id),
                                    ),
                                  );
                                }
                              },
                              cells: [
                                DataCell(
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor:
                                            AppColors.primary.withOpacity(0.1),
                                        child: Text(
                                          customer.fullName.isNotEmpty
                                              ? customer.fullName[0]
                                              : '?',
                                          style: const TextStyle(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(customer.fullName,
                                              style: AppTextStyle.bodySmall
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors
                                                          .textPrimary)),
                                          Text(customer.phone,
                                              style: AppTextStyle.caption),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(Text('${customer.balance} Points')),
                                DataCell(Text(
                                    customer.totalPointsReceived.toString())),
                                DataCell(Text(
                                    '${customer.kiosksInteracted} kiosks')),
                                DataCell(Row(
                                  children: [
                                    if (customer.appDownloaded)
                                      const Icon(Icons.install_mobile,
                                          color: AppColors.success, size: 20),
                                    if (customer.appDownloaded)
                                      const SizedBox(width: 4),
                                    Text(
                                        customer.appDownloaded
                                            ? 'Installed'
                                            : 'Not Installed',
                                        style: AppTextStyle.caption.copyWith(
                                            color: customer.appDownloaded
                                                ? AppColors.success
                                                : AppColors.neutral500)),
                                  ],
                                )),
                                DataCell(Text(DateFormat('MMM d, yyyy')
                                    .format(customer.createdAt))),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    _buildPagination(context, state),
                  ],
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildPagination(BuildContext context, CustomersLoaded state) {
    final totalPages = (state.total / state.limit).ceil();
    if (totalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              'Showing ${(state.page - 1) * state.limit + 1} to ${state.page * state.limit > state.total ? state.total : state.page * state.limit} of ${state.total} customers',
              style: AppTextStyle.caption,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: state.page > 1
                    ? () => context
                        .read<CustomersCubit>()
                        .getCustomers(page: state.page - 1)
                    : null,
                icon: const Icon(Icons.chevron_left),
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text('Page ${state.page} of $totalPages',
                  style: AppTextStyle.bodySmall),
              const SizedBox(width: 8),
              IconButton(
                onPressed: state.page < totalPages
                    ? () => context
                        .read<CustomersCubit>()
                        .getCustomers(page: state.page + 1)
                    : null,
                icon: const Icon(Icons.chevron_right),
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
