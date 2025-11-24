import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_pilot/presentation/widgets/app_button.dart';
import '../../core/animation/animation.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_elevation.dart';
import '../../core/theme/app_fonts.dart';
import '../../domain/entities/travel_entities.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/search/search_bloc.dart';
import '../bloc/search/search_event.dart';
import '../bloc/search/search_state.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/search_input_field.dart';
import '../widgets/flight_card.dart';
import '../widgets/hotel_card.dart';
import '../widgets/activity_card.dart';
import '../widgets/item_image_placeholder.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Controllers for all search types
  late List<TextEditingController> _allControllers;

  // Flights form controllers
  late TextEditingController _flightDepartureController;
  late TextEditingController _flightDestinationController;
  late TextEditingController _flightStartDateController;
  late TextEditingController _flightEndDateController;
  late TextEditingController _flightBudgetController;

  // Hotels form controllers
  late TextEditingController _hotelCityController;
  late TextEditingController _hotelCheckInController;
  late TextEditingController _hotelCheckOutController;
  late TextEditingController _hotelBudgetController;

  // Activities form controllers
  late TextEditingController _activityCityController;
  late TextEditingController _activityDateController;

  // Pagination variables
  int _flightDisplayCount = 5;
  int _hotelDisplayCount = 5;
  int _activityDisplayCount = 5;
  final int _loadMoreCount = 5;

  // Scroll controllers for infinite scroll
  late ScrollController _flightScrollController;
  late ScrollController _hotelScrollController;
  late ScrollController _activityScrollController;
  
  // Loading state for infinite scroll
  bool _flightIsLoading = false;
  bool _hotelIsLoading = false;
  bool _activityIsLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAllControllers();
    _initializeScrollControllers();
  }

  /// Initialize scroll controllers with listeners
  void _initializeScrollControllers() {
    _flightScrollController = ScrollController();
    _hotelScrollController = ScrollController();
    _activityScrollController = ScrollController();

    // Flight scroll listener
    _flightScrollController.addListener(() {
      _onFlightScroll();
    });

    // Hotel scroll listener
    _hotelScrollController.addListener(() {
      _onHotelScroll();
    });

    // Activity scroll listener
    _activityScrollController.addListener(() {
      _onActivityScroll();
    });
  }

  /// Check if user scrolled near bottom for flights
  void _onFlightScroll() {
    if (_flightScrollController.position.pixels >=
        _flightScrollController.position.maxScrollExtent * 0.8) {
      if (!_flightIsLoading) {
        _flightIsLoading = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _flightDisplayCount += _loadMoreCount;
              _flightIsLoading = false;
            });
          }
        });
      }
    }
  }

  /// Check if user scrolled near bottom for hotels
  void _onHotelScroll() {
    if (_hotelScrollController.position.pixels >=
        _hotelScrollController.position.maxScrollExtent * 0.8) {
      if (!_hotelIsLoading) {
        _hotelIsLoading = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _hotelDisplayCount += _loadMoreCount;
              _hotelIsLoading = false;
            });
          }
        });
      }
    }
  }

  /// Check if user scrolled near bottom for activities
  void _onActivityScroll() {
    if (_activityScrollController.position.pixels >=
        _activityScrollController.position.maxScrollExtent * 0.8) {
      if (!_activityIsLoading) {
        _activityIsLoading = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _activityDisplayCount += _loadMoreCount;
              _activityIsLoading = false;
            });
          }
        });
      }
    }
  }

  /// Initialize all text controllers
  void _initializeAllControllers() {
    // Flight controllers
    _flightDepartureController = TextEditingController();
    _flightDestinationController = TextEditingController();
    _flightStartDateController = TextEditingController();
    _flightEndDateController = TextEditingController();
    _flightBudgetController = TextEditingController();

    // Hotel controllers
    _hotelCityController = TextEditingController();
    _hotelCheckInController = TextEditingController();
    _hotelCheckOutController = TextEditingController();
    _hotelBudgetController = TextEditingController();

    // Activity controllers
    _activityCityController = TextEditingController();
    _activityDateController = TextEditingController();

    // Collect all for easy disposal
    _allControllers = [
      _flightDepartureController,
      _flightDestinationController,
      _flightStartDateController,
      _flightEndDateController,
      _flightBudgetController,
      _hotelCityController,
      _hotelCheckInController,
      _hotelCheckOutController,
      _hotelBudgetController,
      _activityCityController,
      _activityDateController,
    ];
  }

  @override
  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _allControllers) {
      controller.dispose();
    }
    // Dispose scroll controllers
    _flightScrollController.dispose();
    _hotelScrollController.dispose();
    _activityScrollController.dispose();
    super.dispose();
  }

  /// Safe method to reset scroll controller
  void _resetScrollController(ScrollController controller) {
    if (controller.hasClients) {
      controller.jumpTo(0.0);
    }
  }

  /// Generic date picker method
  void _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      controller.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Flights & Hotels',
          style: AppFonts.titleLarge().copyWith(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryLight,
        elevation: AppElevation.level3,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            // Tab bar
            TabBar(
              tabs: const [
                Tab(text: 'Flights'),
                Tab(text: 'Hotels'),
                Tab(text: 'Activities'),
              ],
              indicatorColor: AppColors.primaryLight,
              labelColor: AppColors.primaryLight,
              unselectedLabelColor: Colors.grey,
            ),
            // Expanded tab view for responsive height
            Expanded(
              child: TabBarView(
                children: [
                  // Flights Tab
                  _buildFlightSearch(),
                  // Hotels Tab
                  _buildHotelSearch(),
                  // Activities Tab
                  _buildActivitySearch(),
                ],
              ),
            ),
          ],
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

  // ==================== FLIGHTS SECTION ====================

  Widget _buildFlightSearch() {
    return _buildSearchSection(
      scrollController: _flightScrollController,
      items: [
        _buildStaggeredField(
          index: 0,
          child: SearchInputField(
            controller: _flightDepartureController,
            labelText: 'Departure City',
            prefixIcon: Icons.flight_takeoff,
          ),
        ),
        _buildStaggeredField(
          index: 1,
          child: SearchInputField(
            controller: _flightDestinationController,
            labelText: 'Destination City',
            prefixIcon: Icons.flight_land,
          ),
        ),
        _buildStaggeredField(
          index: 2,
          child: SearchInputField(
            controller: _flightStartDateController,
            labelText: 'Departure Date',
            prefixIcon: Icons.calendar_today,
            readOnly: true,
            onDatePickerTap: () =>
                _selectDate(context, _flightStartDateController),
          ),
        ),
        _buildStaggeredField(
          index: 3,
          child: SearchInputField(
            controller: _flightEndDateController,
            labelText: 'Return Date',
            prefixIcon: Icons.calendar_today,
            readOnly: true,
            onDatePickerTap: () =>
                _selectDate(context, _flightEndDateController),
          ),
        ),
        _buildStaggeredField(
          index: 4,
          child: SearchInputField(
            controller: _flightBudgetController,
            labelText: 'Budget',
            prefixIcon: Icons.attach_money,
            keyboardType: TextInputType.number,
          ),
        ),
        _buildStaggeredField(
          index: 5,
          child: AppButton(
            onPressed: () => _onFlightSearchPressed(),
            label: 'Search Flights',
          ),
        ),
        _buildStaggeredField(
          index: 6,
          child: _buildFlightResults(),
        ),
      ],
    );
  }

  void _onFlightSearchPressed() {
    if (_flightDepartureController.text.isNotEmpty &&
        _flightDestinationController.text.isNotEmpty &&
        _flightStartDateController.text.isNotEmpty) {
      // Reset display count and scroll position
      _flightDisplayCount = 5;
      _flightIsLoading = false;
      _resetScrollController(_flightScrollController);
      
      final startDate =
          DateTime.tryParse(_flightStartDateController.text) ?? DateTime.now();
      final returnDate = _flightEndDateController.text.isNotEmpty
          ? DateTime.tryParse(_flightEndDateController.text)
          : null;
      context.read<SearchBloc>().add(
        SearchFlightsRequested(
          departureCity: _flightDepartureController.text,
          arrivalCity: _flightDestinationController.text,
          departureDate: startDate,
          returnDate: returnDate,
        ),
      );
    }
  }

  Widget _buildFlightResults() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const CircularProgressIndicator();
        } else if (state is FlightsSearchSuccess) {
          return _buildInfiniteScrollList(
            title: 'Available Flights',
            items: state.flights,
            displayCount: _flightDisplayCount,
            itemBuilder: (flight) => FlightCard(
              flight: flight,
              onViewDetails: () =>
                  _showFlightDetailsBottomSheet(context, flight),
            ),
            scrollController: _flightScrollController,
            isLoading: _flightIsLoading,
          );
        } else if (state is SearchFailure) {
          return _buildErrorWidget(state.failure.toString());
        }
        return const SizedBox.shrink();
      },
    );
  }

  // ==================== HOTELS SECTION ====================

  Widget _buildHotelSearch() {
    return _buildSearchSection(
      scrollController: _hotelScrollController,
      items: [
        _buildStaggeredField(
          index: 0,
          child: SearchInputField(
            controller: _hotelCityController,
            labelText: 'Destination',
            prefixIcon: Icons.location_on,
          ),
        ),
        _buildStaggeredField(
          index: 1,
          child: SearchInputField(
            controller: _hotelCheckInController,
            labelText: 'Check-in Date',
            prefixIcon: Icons.calendar_today,
            readOnly: true,
            onDatePickerTap: () =>
                _selectDate(context, _hotelCheckInController),
          ),
        ),
        _buildStaggeredField(
          index: 2,
          child: SearchInputField(
            controller: _hotelCheckOutController,
            labelText: 'Check-out Date',
            prefixIcon: Icons.calendar_today,
            readOnly: true,
            onDatePickerTap: () =>
                _selectDate(context, _hotelCheckOutController),
          ),
        ),
        _buildStaggeredField(
          index: 3,
          child: AppButton(
            onPressed: () => _onHotelSearchPressed(),
            label: 'Search Hotels',
          ),
        ),
        _buildStaggeredField(
          index: 4,
          child: _buildHotelResults(),
        ),
      ],
    );
  }

  void _onHotelSearchPressed() {
    if (_hotelCityController.text.isNotEmpty &&
        _hotelCheckInController.text.isNotEmpty &&
        _hotelCheckOutController.text.isNotEmpty) {
      // Reset display count and scroll position
      _hotelDisplayCount = 5;
      _hotelIsLoading = false;
      _resetScrollController(_hotelScrollController);
      
      final checkInDate =
          DateTime.tryParse(_hotelCheckInController.text) ?? DateTime.now();
      final checkOutDate =
          DateTime.tryParse(_hotelCheckOutController.text) ??
              DateTime.now().add(const Duration(days: 1));
      context.read<SearchBloc>().add(
        SearchHotelsRequested(
          city: _hotelCityController.text,
          checkInDate: checkInDate,
          checkOutDate: checkOutDate,
        ),
      );
    }
  }

  Widget _buildHotelResults() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const CircularProgressIndicator();
        } else if (state is HotelsSearchSuccess) {
          return _buildInfiniteScrollList(
            title: 'Available Hotels',
            items: state.hotels,
            displayCount: _hotelDisplayCount,
            itemBuilder: (hotel) => HotelCard(
              hotel: hotel,
              onViewDetails: () =>
                  _showHotelDetailsBottomSheet(context, hotel),
            ),
            scrollController: _hotelScrollController,
            isLoading: _hotelIsLoading,
          );
        } else if (state is SearchFailure) {
          return _buildErrorWidget(state.failure.toString());
        }
        return const SizedBox.shrink();
      },
    );
  }

  // ==================== ACTIVITIES SECTION ====================

  Widget _buildActivitySearch() {
    return _buildSearchSection(
      scrollController: _activityScrollController,
      items: [
        _buildStaggeredField(
          index: 0,
          child: SearchInputField(
            controller: _activityCityController,
            labelText: 'Destination',
            prefixIcon: Icons.location_on,
          ),
        ),
        _buildStaggeredField(
          index: 1,
          child: AppButton(
            onPressed: () => _onActivitySearchPressed(),
            label: 'Search Activities',
          ),
        ),
        _buildStaggeredField(
          index: 2,
          child: _buildActivityResults(),
        ),
      ],
    );
  }

  void _onActivitySearchPressed() {
    if (_activityCityController.text.isNotEmpty) {
      // Reset display count and scroll position
      _activityDisplayCount = 5;
      _activityIsLoading = false;
      _resetScrollController(_activityScrollController);
      
      context.read<SearchBloc>().add(
        SearchActivitiesRequested(
          city: _activityCityController.text,
        ),
      );
    }
  }

  Widget _buildActivityResults() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const CircularProgressIndicator();
        } else if (state is ActivitiesSearchSuccess) {
          return _buildInfiniteScrollList(
            title: 'Available Activities',
            items: state.activities,
            displayCount: _activityDisplayCount,
            itemBuilder: (activity) => ActivityCard(
              activity: activity,
              onViewDetails: () => _showActivityDetailsBottomSheet(
                context,
                activity,
              ),
            ),
            scrollController: _activityScrollController,
            isLoading: _activityIsLoading,
          );
        } else if (state is SearchFailure) {
          return _buildErrorWidget(state.failure.toString());
        }
        return const SizedBox.shrink();
      },
    );
  }

  // ==================== COMMON WIDGETS ====================

  /// Generic search section builder
  Widget _buildSearchSection({required List<Widget> items, ScrollController? scrollController}) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(children: items),
    );
  }

  /// Wraps a field with staggered animation
  Widget _buildStaggeredField({required int index, required Widget child}) {
    final spacing = index < 5 ? 16.0 : 12.0;
    return StaggeredContainer(
      index: index,
      config: StaggerConfig(
        duration: AnimationConstants.standard,
        staggerType: StaggerType.staggered,
      ),
      child: Column(
        children: [
          child,
          SizedBox(height: spacing),
        ],
      ),
    );
  }

  /// Generic infinite scroll results list builder
  Widget _buildInfiniteScrollList<T>({
    required String title,
    required List<T> items,
    required int displayCount,
    required Widget Function(T) itemBuilder,
    required ScrollController scrollController,
    required bool isLoading,
  }) {
    final visibleItems = items.take(displayCount).toList();
    final hasMoreItems = items.length > displayCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with result count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${visibleItems.length} / ${items.length}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Items - use Column with all items since outer SingleChildScrollView handles scrolling
        ...visibleItems.map((item) => itemBuilder(item)),
        // Loading indicator
        if (hasMoreItems)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : SizedBox(
                      height: 24,
                      width: 24,
                      child: GestureDetector(
                        onTap: () {
                          // Manual trigger if needed - but infinite scroll should auto-load
                        },
                        child: Text(
                          'Scroll to load more',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
            ),
          ),
      ],
    );
  }

  /// Generic error widget
  Widget _buildErrorWidget(String message) {
    return Text(
      'Error: $message',
      style: const TextStyle(color: Colors.red),
    );
  }

  // ==================== BOTTOM SHEETS ====================

  /// Flight details bottom sheet
  void _showFlightDetailsBottomSheet(BuildContext context, Flight flight) {
    final duration = Duration(minutes: flight.duration);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    _showDetailsBottomSheet(
      context: context,
      imageUrl: null,
      imageIcon: Icons.flight_takeoff,
      title: flight.airline,
      rating: null,
      price: '\$${flight.price.toStringAsFixed(2)}',
      priceLabel: flight.currency,
      description:
          'Flight ${flight.flightNumber}\nDuration: $hours hours $minutes minutes',
      onBookPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking ${flight.airline} flight...'),
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      },
      infoSections: [
        _buildFlightInfoSection(flight, hours, minutes),
      ],
    );
  }

  /// Hotel details bottom sheet
  void _showHotelDetailsBottomSheet(BuildContext context, Hotel hotel) {
    _showDetailsBottomSheet(
      context: context,
      imageUrl: hotel.imageUrl,
      imageIcon: Icons.hotel,
      title: hotel.name,
      rating: hotel.rating,
      reviewCount: hotel.reviewCount.toString(),
      price: '\$${hotel.pricePerNight.toStringAsFixed(0)}',
      priceLabel: 'per night',
      description: hotel.description,
      onBookPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking ${hotel.name}...'),
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      },
      infoSections: [
        _buildLocationInfoSection(
          city: hotel.location.city ?? 'Unknown',
          distance: hotel.distance > 0 ? hotel.distance : null,
          address: hotel.location.address,
        ),
      ],
      amenitiesSection:
          hotel.amenities.isNotEmpty ? hotel.amenities : null,
    );
  }

  /// Activity details bottom sheet
  void _showActivityDetailsBottomSheet(
    BuildContext context,
    Activity activity,
  ) {
    _showDetailsBottomSheet(
      context: context,
      imageUrl: activity.imageUrl,
      imageIcon: Icons.local_activity,
      title: activity.name,
      rating: activity.rating,
      price: activity.price != null
          ? '\$${activity.price!.toStringAsFixed(0)}'
          : null,
      priceLabel: 'per person',
      description: activity.description,
      onBookPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking ${activity.name}...'),
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      },
      infoSections: [
        _buildActivityInfoSection(activity),
      ],
    );
  }

  /// Generic bottom sheet for details
  void _showDetailsBottomSheet({
    required BuildContext context,
    String? imageUrl,
    required IconData imageIcon,
    required String title,
    double? rating,
    String? reviewCount,
    String? price,
    String? priceLabel,
    String? description,
    required VoidCallback onBookPressed,
    List<Widget>? infoSections,
    List<String>? amenitiesSection,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                _buildDragHandle(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      ItemImagePlaceholder(
                        imageUrl: imageUrl,
                        placeholderIcon: imageIcon,
                        width: double.infinity,
                        height: 200,
                      ),
                      const SizedBox(height: 20),
                      // Title and rating
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (rating != null)
                                  _buildRatingRow(rating, reviewCount),
                              ],
                            ),
                          ),
                          if (price != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  price,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryLight,
                                  ),
                                ),
                                if (priceLabel != null)
                                  Text(
                                    priceLabel,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Info sections
                      if (infoSections != null)
                        ...infoSections
                            .map((section) =>
                                [section, const SizedBox(height: 20)])
                            .expand((e) => e)
                            .toList(),
                      // Description
                      if (description != null) ...[
                        Text(
                          'About',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      // Amenities
                      if (amenitiesSection != null &&
                          amenitiesSection.isNotEmpty) ...[
                        Text(
                          'Amenities',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: amenitiesSection
                              .map((amenity) => _buildAmenityChip(amenity))
                              .toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                      // Book button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: onBookPressed,
                          icon: const Icon(Icons.bookmark),
                          label: const Text('Book Now'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryLight,
                            side: const BorderSide(
                              color: AppColors.primaryLight,
                              width: 2,
                            ),
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Drag handle bar for bottom sheet
  Widget _buildDragHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 16),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  /// Rating row for bottom sheet header
  Widget _buildRatingRow(double rating, String? reviewCount) {
    return Row(
      children: [
        const Icon(
          Icons.star,
          size: 18,
          color: Colors.amber,
        ),
        const SizedBox(width: 4),
        Text(
          reviewCount != null
              ? '$rating (${reviewCount} reviews)'
              : '${rating.toStringAsFixed(1)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Location info section for bottom sheet
  Widget _buildLocationInfoSection({
    required String city,
    double? distance,
    String? address,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryLight.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 18,
                color: AppColors.primaryLight,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  city,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (distance != null && distance > 0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.directions_walk,
                  size: 18,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Text(
                  '${distance.toStringAsFixed(1)} km from city center',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
          if (address != null) ...[
            const SizedBox(height: 8),
            Text(
              address,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Activity info section for bottom sheet
  Widget _buildActivityInfoSection(Activity activity) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryLight.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_activity,
                size: 18,
                color: AppColors.primaryLight,
              ),
              const SizedBox(width: 8),
              Text(
                activity.category,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (activity.location.city != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 18,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Text(
                  activity.location.city!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
          if (activity.duration != null && activity.duration! > 0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.timer,
                  size: 18,
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  '${activity.duration} hours',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Amenity chip widget
  Widget _buildAmenityChip(String amenity) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            size: 14,
            color: AppColors.primaryLight,
          ),
          const SizedBox(width: 6),
          Text(
            amenity,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Flight info section for bottom sheet
  Widget _buildFlightInfoSection(Flight flight, int hours, int minutes) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryLight.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Flight number
          Row(
            children: [
              const Icon(
                Icons.confirmation_number,
                size: 18,
                color: AppColors.primaryLight,
              ),
              const SizedBox(width: 8),
              Text(
                'Flight ${flight.flightNumber}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Departure
          Row(
            children: [
              const Icon(
                Icons.flight_takeoff,
                size: 18,
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flight.departure.city ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      flight.departureTime.hour.toString().padLeft(2, '0') +
                          ':' +
                          flight.departureTime.minute.toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Duration
          Row(
            children: [
              const Icon(
                Icons.timer,
                size: 18,
                color: Colors.green,
              ),
              const SizedBox(width: 8),
              Text(
                '$hours h $minutes m',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Arrival
          Row(
            children: [
              const Icon(
                Icons.flight_land,
                size: 18,
                color: Colors.orange,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flight.arrival.city ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      flight.arrivalTime.hour.toString().padLeft(2, '0') +
                          ':' +
                          flight.arrivalTime.minute.toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
