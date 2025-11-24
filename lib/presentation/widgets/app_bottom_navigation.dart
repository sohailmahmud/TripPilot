import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/navigation/navigation_item.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class NavItem {
  final String label;
  final IconData icon;
  final String route;
  final Color activeColor;
  final Color inactiveColor;

  NavItem({
    required this.label,
    required this.icon,
    required this.route,
    required this.activeColor,
    required this.inactiveColor,
  });
}

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final List<NavItem> items;
  final ValueChanged<int> onItemSelected;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Custom layout: Home | Search | [Ideas FAB] | Budget | Account
    return Container(
      height: 100,
      padding: EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Bottom navigation bar background
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Home
              _buildNavItem(context, 0, items[0]),
              // Search
              _buildNavItem(context, 1, items[1]),
              // Spacer for FAB
              SizedBox(width: 80),
              // Budget
              _buildNavItem(context, 3, items[3]),
              // Account
              _buildNavItem(context, 4, items[4]),
            ],
          ),
          // Floating Ideas button (center)
          Positioned(
            left: 0,
            right: 0,
            top: -28,
            child: Center(
              child: GestureDetector(
                onTap: () => onItemSelected(2),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: currentIndex == 2 ? 1.0 : 0.0),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 0.95 + (value * 0.05),
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryLight,
                              AppColors.warningLight,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryLight.withOpacity(0.35 + (value * 0.15)),
                              blurRadius: 20 + (value * 8),
                              offset: Offset(0, 8 + (value * 2)),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1 + (value * 0.05)),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          items[2].icon,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, NavItem item) {
    final isActive = currentIndex == index;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onItemSelected(index),
          splashColor: AppColors.primaryLight.withOpacity(0.1),
          highlightColor: AppColors.primaryLight.withOpacity(0.05),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: isActive ? 1.0 : 0.0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Icon container with professional styling
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? AppColors.primaryLight.withValues(alpha: 0.15 + (value * 0.08))
                          : Colors.transparent,
                    ),
                    child: Center(
                      child: Transform.scale(
                        scale: 0.85 + (value * 0.15),
                        child: Icon(
                          item.icon,
                          color: Color.lerp(
                            Colors.grey[600],
                            AppColors.primaryLight,
                            value,
                          ),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2),
                  // Label with smooth animation
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: 10,
                      height: 1.2,
                      color: Color.lerp(
                        Colors.grey[700],
                        AppColors.primaryLight,
                        value,
                      ),
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class AppNavigation {
  static List<NavItem> getNavItems(BuildContext context) {
    return NavigationItem.values
        .map(
          (item) => NavItem(
            label: item.label,
            icon: item.icon,
            route: item.route,
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Colors.grey,
          ),
        )
        .toList();
  }

  static void navigateTo(BuildContext context, int index) {
    final item = NavigationItem.fromIndex(index);
    context.go(item.route);
  }

  static int getCurrentIndex(String location) {
    return NavigationItem.getIndexFromRoute(location);
  }
}

