import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/animation/animation.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_elevation.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_spacing.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/app_button.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: AppFonts.titleLarge().copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryLight,
        elevation: AppElevation.level3,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSpacing.contentPadding,
          child: StaggeredListView(
            config: StaggerConfig(
              duration: AnimationConstants.standard,
              staggerType: StaggerType.staggered,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              StaggeredContainer(
                index: 0,
                child: Container(
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariantLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryLight,
                              AppColors.secondaryLight,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      SizedBox(width: AppSpacing.lg),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Doe',
                            style: AppFonts.titleLarge(),
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Text(
                            'john.doe@example.com',
                            style: AppFonts.bodySmall().copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.xxl),
              StaggeredContainer(
                index: 1,
                child: Text(
                  'Settings',
                  style: AppFonts.titleLarge(),
                ),
              ),
              SizedBox(height: AppSpacing.md),
              StaggeredContainer(
                index: 2,
                child: _buildSettingTile(
                  context,
                  Icons.notifications_rounded,
                  'Notifications',
                  'Manage your notification preferences',
                ),
              ),
              SizedBox(height: AppSpacing.md),
              StaggeredContainer(
                index: 3,
                child: _buildSettingTile(
                  context,
                  Icons.security_rounded,
                  'Security',
                  'Manage your account security',
                ),
              ),
              SizedBox(height: AppSpacing.md),
              StaggeredContainer(
                index: 4,
                child: _buildSettingTile(
                  context,
                  Icons.language_rounded,
                  'Language',
                  'Choose your preferred language',
                ),
              ),
              SizedBox(height: AppSpacing.md),
              StaggeredContainer(
                index: 5,
                child: _buildSettingTile(
                  context,
                  Icons.info_rounded,
                  'About',
                  'Learn more about Trip Pilot',
                ),
              ),
              SizedBox(height: AppSpacing.xxl),
              StaggeredContainer(
                index: 6,
                child: AppButton(
                  label: 'Logout',
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthSignOutRequested());
                  },
                  style: AppButtonStyle.error,
                  size: ButtonSize.large,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, navState) {
          final location = GoRouterState.of(context).uri.toString();
          final currentIndex = AppNavigation.getCurrentIndex(location);

          return AppBottomNavigation(
            currentIndex: currentIndex,
            items: AppNavigation.getNavItems(context),
            onItemSelected: (index) {
              context.read<NavigationBloc>().add(
                NavigationIndexChanged(index),
              );
              AppNavigation.navigateTo(context, index);
            },
          );
        },
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.primaryLight,
        ),
        title: Text(
          title,
          style: AppFonts.titleMedium(),
        ),
        subtitle: Text(
          subtitle,
          style: AppFonts.bodySmall(),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: Colors.grey,
        ),
        onTap: () {},
      ),
    );
  }
}
