import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../core/animation/animation.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_elevation.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_spacing.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/trip/trip_bloc.dart';
import '../bloc/trip/trip_event.dart';
import '../bloc/trip/trip_state.dart';
import '../widgets/app_bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Get current location to use as a key for rebuilding animations
    final currentLocation = GoRouterState.of(context).uri.toString();
    
    return Scaffold(
      key: ValueKey<String>('home_$currentLocation'),
      appBar: AppBar(
        title: const Text('Trip Pilot'),
        elevation: AppElevation.level0,
        backgroundColor: AppColors.primaryLight,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                context.read<AuthBloc>().add(const AuthSignOutRequested());
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<TripBloc>().add(const FetchTripsRequested());
          // Wait for the bloc to emit a state
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          key: const PageStorageKey<String>('home_screen_body'),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            key: ValueKey<String>('home_content_$currentLocation'),
            children: [
              _buildWelcomeHeader(),
              Padding(
                padding: AppSpacing.contentPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Plan Your Next Trip', index: 1),
                    SizedBox(height: AppSpacing.lg),
                    _buildActionCards(),
                    SizedBox(height: AppSpacing.xxl),
                    _buildSectionTitle('My Trips', index: 4),
                    SizedBox(height: AppSpacing.md),
                    _buildTripsSection(),
                  ],
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
              // Update BLOC state first to reflect the selection
              context.read<NavigationBloc>().add(
                NavigationIndexChanged(index),
              );
              // Navigate immediately
              AppNavigation.navigateTo(context, index);
            },
          );
        },
      ),
    );
  }

  /// Builds the welcome header with gradient
  Widget _buildWelcomeHeader() {
    return StaggeredContainer(
      index: 0,
      config: StaggerConfig(
        duration: AnimationConstants.slow,
        staggerType: StaggerType.sequential,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSpacing.xxl),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryLight,
              AppColors.secondaryLight,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Trip Pilot',
              style: AppFonts.headlineLarge().copyWith(
                color: Colors.white,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Your AI-powered travel planning assistant',
              style: AppFonts.bodyLarge().copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a reusable section title
  Widget _buildSectionTitle(String title, {required int index}) {
    return StaggeredContainer(
      index: index,
      config: StaggerConfig(
        duration: AnimationConstants.standard,
        staggerType: StaggerType.staggered,
      ),
      child: Text(
        title,
        style: AppFonts.titleLarge(),
      ),
    );
  }

  /// Builds action cards using DRY principle
  Widget _buildActionCards() {
    final cards = [
      _ActionCard(
        iconPath: 'assets/icons/flight.svg',
        color: AppColors.primaryLight,
        title: 'Search Flights & Hotels',
        subtitle: 'Find the best deals',
        route: '/search',
      ),
      _ActionCard(
        iconPath: 'assets/icons/budget.svg',
        color: AppColors.successLight,
        title: 'Budget Tracker',
        subtitle: 'Optimize your spending',
        route: '/budget',
      ),
      _ActionCard(
        iconPath: 'assets/icons/sparkle.svg',
        color: AppColors.warningLight,
        title: 'AI Recommendations',
        subtitle: 'Get personalized suggestions',
        route: '/recommendations',
      ),
    ];

    return StaggeredListView(
      config: StaggerConfig(
        duration: AnimationConstants.standard,
        delay: Duration(milliseconds: 200),
        staggerType: StaggerType.staggered,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: cards.map((card) => card.build()).toList(),
    );
  }

  /// Builds the trips section with BLoC integration
  Widget _buildTripsSection() {
    return BlocBuilder<TripBloc, TripState>(
      builder: (context, state) {
        if (state is TripsLoadSuccess) {
          if (state.trips.isEmpty) {
            return _buildEmptyState(
              'No trips yet. Create one to get started!',
              index: 5,
            );
          }
          return _buildTripsList(state.trips);
        } else if (state is TripLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return _buildEmptyState(
            'No trips yet. Create one to get started!',
            index: 5,
          );
        }
      },
    );
  }

  /// Builds a reusable empty state widget
  Widget _buildEmptyState(String message, {required int index}) {
    return StaggeredContainer(
      index: index,
      child: Center(
        child: Padding(
          padding: AppSpacing.dialogPadding,
          child: Text(
            message,
            style: AppFonts.bodyMedium(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  /// Builds the trips list with animations
  Widget _buildTripsList(List<dynamic> trips) {
    return StaggeredListView(
      config: StaggerConfig(
        duration: AnimationConstants.standard,
        delay: Duration(milliseconds: 400),
        staggerType: StaggerType.staggered,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: trips.map((trip) {
        return Builder(
          builder: (context) => Card(
            margin: EdgeInsets.only(bottom: AppSpacing.md),
            elevation: AppElevation.level1,
            child: ListTile(
              title: Text(
                trip.name,
                style: AppFonts.titleMedium(),
              ),
              subtitle: Text(
                trip.destination,
                style: AppFonts.bodySmall(),
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: AppColors.primaryLight,
                size: 24,
              ),
              onTap: () => context.go(
                '/trip-details',
                extra: trip.id,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Reusable action card model and builder
class _ActionCard {
  final String iconPath;
  final Color color;
  final String title;
  final String subtitle;
  final String route;

  _ActionCard({
    required this.iconPath,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  Widget build() {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () => context.go(route),
        child: Column(
          children: [
            Card(
              elevation: AppElevation.level2,
              child: ListTile(
                contentPadding: AppSpacing.cardPadding,
                leading: SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(
                    color,
                    BlendMode.srcIn,
                  ),
                  width: 28,
                  height: 28,
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
                  color: AppColors.textDisabledLight,
                  size: 24,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
