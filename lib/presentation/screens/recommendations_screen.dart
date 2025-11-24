import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/animation/animation.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_elevation.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_spacing.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/recommendations/recommendations_bloc.dart';
import '../bloc/recommendations/recommendations_event.dart';
import '../bloc/recommendations/recommendations_state.dart';
import '../widgets/app_bottom_navigation.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  late TextEditingController _destinationController;

  @override
  void initState() {
    super.initState();
    _destinationController = TextEditingController();
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Recommendations',
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
            key: ValueKey<String>('recommendations_list_$currentLocation'),
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
                  'Get AI-Powered Recommendations',
                  style: AppFonts.titleLarge(),
                ),
              ),
              const SizedBox(height: 16),
              StaggeredContainer(
                index: 1,
                child: TextField(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    labelText: 'Destination',
                    prefixIcon: const Icon(Icons.location_on),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              StaggeredContainer(
                index: 2,
                child: ElevatedButton(
                  onPressed: () {
                    if (_destinationController.text.isNotEmpty) {
                      context.read<RecommendationBloc>().add(
                            GetRecommendationsRequested(
                              destination: _destinationController.text,
                              numberOfDays: 7,
                              budget: 2000,
                              preferences: const ['relaxation', 'adventure', 'culture'],
                            ),
                          );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warningLight,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(
                    'Get Recommendations',
                    style: AppFonts.labelLarge().copyWith(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<RecommendationBloc, RecommendationState>(
                builder: (context, state) {
                  if (state is RecommendationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is RecommendationSuccess) {
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
                          'Recommendations for ${state.destination}',
                          style: AppFonts.titleLarge(),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(
                          state.recommendations.length,
                          (index) {
                            final rec = state.recommendations[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Padding(
                                padding: AppSpacing.cardPadding,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            rec['name'] ?? 'Recommendation',
                                            style: AppFonts.titleMedium(),
                                          ),
                                        ),
                                        Text(
                                          '${rec['rating'] ?? 4.5}⭐',
                                          style: AppFonts.labelLarge(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    if (rec['description'] != null)
                                      Text(
                                        rec['description'] as String,
                                        style: AppFonts.bodySmall().copyWith(
                                          color: AppColors.textSecondaryLight,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  } else if (state is PersonalizedRecommendationSuccess) {
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
                          'Your Personalized Recommendations',
                          style: AppFonts.titleLarge(),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(
                          state.recommendations.length,
                          (index) {
                            final rec = state.recommendations[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Padding(
                                padding: AppSpacing.cardPadding,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rec['title'] ?? 'Recommendation ${index + 1}',
                                      style: AppFonts.titleMedium(),
                                    ),
                                    const SizedBox(height: 4),
                                    if (rec['description'] != null)
                                      Text(
                                        rec['description'].toString(),
                                        style: AppFonts.bodySmall().copyWith(
                                          color: AppColors.textSecondaryLight,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  } else if (state is RecommendationFailure) {
                    return StaggeredContainer(
                      index: 3,
                      child: Text(
                        'Error: ${state.failure.toString()}',
                        style: AppFonts.bodyMedium().copyWith(
                          color: AppColors.errorLight,
                        ),
                      ),
                    );
                  } else if (state is RecommendationEmpty) {
                    return StaggeredContainer(
                      index: 3,
                      child: Center(
                        child: Text(
                          state.message,
                          style: AppFonts.bodyMedium().copyWith(
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
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
}
