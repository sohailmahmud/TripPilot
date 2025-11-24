import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/animation/animation.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_elevation.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_spacing.dart';
import '../bloc/budget/budget_bloc.dart';
import '../bloc/budget/budget_event.dart';
import '../bloc/budget/budget_state.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../widgets/app_bottom_navigation.dart';

class BudgetTrackerScreen extends StatefulWidget {
  const BudgetTrackerScreen({super.key});

  @override
  State<BudgetTrackerScreen> createState() => _BudgetTrackerScreenState();
}

class _BudgetTrackerScreenState extends State<BudgetTrackerScreen> {
  late TextEditingController _budgetController;

  @override
  void initState() {
    super.initState();
    _budgetController = TextEditingController();
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Budget Tracker',
          style: AppFonts.titleLarge().copyWith(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryLight,
        elevation: AppElevation.level3,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSpacing.contentPadding,
          child: StaggeredListView(
            key: ValueKey<String>('budget_list_$currentLocation'),
            config: StaggerConfig(
              duration: AnimationConstants.standard,
              staggerType: StaggerType.staggered,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              StaggeredContainer(
                index: 0,
                child: Text(
                  'Set Your Budget',
                  style: AppFonts.titleLarge(),
                ),
              ),
              const SizedBox(height: 16),
              StaggeredContainer(
                index: 1,
                child: TextField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Total Budget (\$)',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              StaggeredContainer(
                index: 2,
                child: ElevatedButton(
                  onPressed: () {
                    if (_budgetController.text.isNotEmpty) {
                      final budget = double.tryParse(_budgetController.text) ?? 0;
                      context.read<BudgetBloc>().add(
                            OptimizeBudgetRequested(
                              totalBudget: budget,
                              numberOfDays: 7,
                              numberOfPeople: 1,
                            ),
                          );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAccentLight,
                    minimumSize: const Size(double.infinity, 48),
                    elevation: 4,
                    shadowColor: AppColors.primaryAccentLight.withValues(alpha: 150)
                  ),
                  child: Text(
                    'Optimize Budget',
                    style: AppFonts.labelLarge().copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<BudgetBloc, BudgetState>(
                builder: (context, state) {
                  if (state is BudgetLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is BudgetOptimizeSuccess) {
                    final breakdown = state.breakdown;
                    return StaggeredListView(
                      config: StaggerConfig(
                        duration: AnimationConstants.standard,
                        delay: Duration(milliseconds: 200),
                        staggerType: StaggerType.staggered,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Text(
                          'Budget Breakdown',
                          style: AppFonts.titleLarge(),
                        ),
                        const SizedBox(height: 16),
                        _buildBudgetCard('Flights', breakdown.flightCost, AppColors.infoLight),
                        _buildBudgetCard('Hotels', breakdown.hotelCost, AppColors.successLight),
                        _buildBudgetCard('Activities', breakdown.activitiesCost, AppColors.warningLight),
                        _buildBudgetCard('Food', breakdown.foodEstimate, AppColors.errorLight),
                        _buildBudgetCard('Transport', breakdown.transportEstimate, AppColors.primaryLight),
                        _buildBudgetCard('Contingency', breakdown.contingency, AppColors.textSecondaryLight),
                        const SizedBox(height: 16),
                        Card(
                          color: AppColors.surfaceVariantLight,
                          child: Padding(
                            padding: AppSpacing.cardPadding,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Allocated:',
                                  style: AppFonts.titleMedium(),
                                ),
                                Text(
                                  '\$${breakdown.totalAllocated.toStringAsFixed(2)}',
                                  style: AppFonts.titleLarge().copyWith(
                                    color: AppColors.primaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state is DealDetectionSuccess) {
                    return StaggeredListView(
                      config: StaggerConfig(
                        duration: AnimationConstants.standard,
                        delay: Duration(milliseconds: 200),
                        staggerType: StaggerType.staggered,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Text(
                          'Available Deals',
                          style: AppFonts.titleLarge(),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(
                          state.deals.length,
                          (index) {
                            final deal = state.deals[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text(
                                  deal.title,
                                  style: AppFonts.titleMedium(),
                                ),
                                subtitle: Text(
                                  'Save: ${deal.savingsPercentage}%',
                                  style: AppFonts.bodySmall(),
                                ),
                                trailing: Text(
                                  '\$${deal.savingsAmount.toStringAsFixed(2)}',
                                  style: AppFonts.labelLarge().copyWith(
                                    color: AppColors.successLight,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  } else if (state is BudgetFailure) {
                    return StaggeredContainer(
                      index: 3,
                      child: Text(
                        'Error: ${state.failure.toString()}',
                        style: AppFonts.bodyMedium().copyWith(
                          color: AppColors.errorLight,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 24),
              StaggeredContainer(
                index: 4,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<BudgetBloc>().add(
                          const DetectDealsRequested(
                            flights: null,
                            hotels: null,
                            activities: null,
                          ),
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textPrimaryDark,
                    minimumSize: const Size(double.infinity, 48),
                    side: BorderSide(color: AppColors.textTertiaryLight),
                    elevation: 4,
                    shadowColor: AppColors.tertiaryLight.withValues(alpha: 0.5),
                  ),
                  child: Text(
                    'Find Deals',
                    style: AppFonts.labelLarge().copyWith(
                      color: AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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

  Widget _buildBudgetCard(String label, double amount, Color color) {
    return StaggeredContainer(
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Container(
            width: 8,
            height: 50,
            color: color,
          ),
          title: Text(
            label,
            style: AppFonts.titleMedium(),
          ),
          trailing: Text(
            '\$${amount.toStringAsFixed(2)}',
            style: AppFonts.labelLarge(),
          ),
        ),
      ),
    );
  }
}
