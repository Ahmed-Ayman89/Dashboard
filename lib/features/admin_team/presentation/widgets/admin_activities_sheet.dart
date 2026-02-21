import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helper/app_text_style.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/admin_model.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../../domain/usecases/get_admin_activities_usecase.dart';
import '../cubit/admin_activities_cubit.dart';
import '../cubit/admin_activities_state.dart';
import 'package:intl/intl.dart';

class AdminActivitiesSheet extends StatelessWidget {
  final AdminUser admin;

  const AdminActivitiesSheet({super.key, required this.admin});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repository = AdminRepositoryImpl();
        return AdminActivitiesCubit(GetAdminActivitiesUseCase(repository))
          ..getActivities(admin.id);
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Activities', style: AppTextStyle.heading3),
                    const SizedBox(height: 4),
                    Text(admin.fullName,
                        style: AppTextStyle.bodyRegular
                            .copyWith(color: AppColors.neutral500)),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<AdminActivitiesCubit, AdminActivitiesState>(
                builder: (context, state) {
                  if (state is AdminActivitiesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AdminActivitiesFailure) {
                    return Center(child: Text(state.message));
                  } else if (state is AdminActivitiesLoaded) {
                    if (state.activities.isEmpty) {
                      return Center(
                          child: Text('No activities found',
                              style: AppTextStyle.bodyRegular));
                    }
                    return ListView.separated(
                      itemCount: state.activities.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 24),
                      itemBuilder: (context, index) {
                        final activity = state.activities[index];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.history,
                                  color: AppColors.primary, size: 20),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(activity.action,
                                      style: AppTextStyle.bodyMedium.copyWith(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('MMM d, yyyy h:mm a')
                                        .format(activity.createdAt),
                                    style: AppTextStyle.caption
                                        .copyWith(color: AppColors.neutral500),
                                  ),
                                  if (activity.formattedDetails != null &&
                                      activity
                                          .formattedDetails!.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      activity.formattedDetails!,
                                      style: AppTextStyle.bodySmall.copyWith(
                                          color: AppColors.neutral700),
                                    ),
                                  ] else if (activity.details != null &&
                                      activity.details!.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      activity.details.toString(),
                                      style: AppTextStyle.bodySmall.copyWith(
                                          color: AppColors.neutral700),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
