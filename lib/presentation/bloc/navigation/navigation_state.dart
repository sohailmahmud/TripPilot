part of 'navigation_bloc.dart';

abstract class NavigationState extends Equatable {
  final int selectedIndex;
  final String? selectedRoute;

  const NavigationState({
    required this.selectedIndex,
    this.selectedRoute,
  });

  @override
  List<Object?> get props => [selectedIndex, selectedRoute];
}

class NavigationInitial extends NavigationState {
  const NavigationInitial()
      : super(
        selectedIndex: 0,
        selectedRoute: null,
      );
}

class NavigationChanged extends NavigationState {
  const NavigationChanged({
    required int selectedIndex,
    String? selectedRoute,
  }) : super(
    selectedIndex: selectedIndex,
    selectedRoute: selectedRoute,
  );
}
