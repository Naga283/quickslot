import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/venues_providers.dart';
import '../../../../core/network/socket_service.dart';
import '../../domain/models/venue.dart';

// Local providers for listing state
final selectedSportTypeProvider = StateProvider<String?>((ref) => null);
final searchTexFilterProvider = StateProvider<String>((ref) => '');

class VenueListView extends ConsumerWidget {
  const VenueListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Listen to Socket.IO notifications (e.g. waitlist promotions)
    ref.listen(socketServiceProvider, (previous, next) {
      if (next != null) {
        if (!context.mounted) return;
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 6),
            action: SnackBarAction(
              label: 'View',
              textColor: Colors.white,
              onPressed: () {
                context.push('/bookings');
              },
            ),
          ),
        );
        ref.read(socketServiceProvider.notifier).clearNotification();
      }
    });

    // Watch Auth state
    final currentUser = ref.watch(currentUserProvider);

    // Watch filter states
    final selectedSportType = ref.watch(selectedSportTypeProvider);
    final searchText = ref.watch(searchTexFilterProvider);

    // Watch query provider (fetching first page)
    final venuesFuture = ref.watch(
      fetchVenuesProvider(
        sportType: selectedSportType,
        page: 1,
        limit: 50, // Grab a large list to allow client-side search filtering
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            // Top App Bar
            SliverAppBar(
              floating: true,
              snap: true,
              expandedHeight: 80.0,
              backgroundColor: theme.scaffoldBackgroundColor,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'QuickSlot',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Welcome back, ${currentUser?.name ?? "User"} 👋',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          // My Bookings button
                          IconButton.filledTonal(
                            onPressed: () {
                              context.push('/bookings');
                            },
                            icon: const Icon(
                              Icons.calendar_today_rounded,
                              size: 20,
                            ),
                            tooltip: 'My Bookings',
                          ),
                          const SizedBox(width: 8),
                          // Logout button
                          IconButton.filledTonal(
                            onPressed: () async {
                              await ref
                                  .read(currentUserProvider.notifier)
                                  .logout();
                            },
                            icon: const Icon(Icons.logout_rounded, size: 20),
                            tooltip: 'Logout',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          body: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(fetchVenuesProvider);
            },
            child: CustomScrollView(
              slivers: [
                // Search Field & Category Chips
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Search bar
                        TextField(
                          onChanged: (val) {
                            ref.read(searchTexFilterProvider.notifier).state =
                                val;
                          },
                          decoration: InputDecoration(
                            hintText: 'Search venues by name...',
                            prefixIcon: const Icon(Icons.search_rounded),
                            filled: true,
                            fillColor: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Sport Type Category Chips
                        SizedBox(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildCategoryChip(
                                ref: ref,
                                label: 'All',
                                value: null,
                                currentValue: selectedSportType,
                              ),
                              _buildCategoryChip(
                                ref: ref,
                                label: 'Badminton',
                                value: 'Badminton',
                                currentValue: selectedSportType,
                              ),
                              _buildCategoryChip(
                                ref: ref,
                                label: 'Football',
                                value: 'Football',
                                currentValue: selectedSportType,
                              ),
                              _buildCategoryChip(
                                ref: ref,
                                label: 'Cricket',
                                value: 'Cricket',
                                currentValue: selectedSportType,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),

                // Venues List Content
                venuesFuture.when(
                  loading: () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, stack) => SliverFillRemaining(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 48,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load venues',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(err.toString(), textAlign: TextAlign.center),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              ref.invalidate(fetchVenuesProvider);
                            },
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  data: (data) {
                    final allVenues = data.$1;

                    // Client side search filtering
                    final filteredVenues = allVenues.where((venue) {
                      return venue.name.toLowerCase().contains(
                        searchText.toLowerCase(),
                      );
                    }).toList();

                    if (filteredVenues.isEmpty) {
                      return SliverFillRemaining(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.sports_tennis_rounded,
                                size: 64,
                                color: theme.colorScheme.primary.withOpacity(
                                  0.3,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No venues found',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Try modifying your search text or category filter.',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 8.0,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final venue = filteredVenues[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _buildVenueCard(
                              context,
                              theme,
                              isDark,
                              venue,
                            ),
                          );
                        }, childCount: filteredVenues.length),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required WidgetRef ref,
    required String label,
    required String? value,
    required String? currentValue,
  }) {
    final isSelected = currentValue == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            ref.read(selectedSportTypeProvider.notifier).state = value;
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildVenueCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    Venue venue,
  ) {
    final imageUrl = _venueImageUrl(venue);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark
              ? const Color(0xFF334155).withOpacity(0.5) // Slate 700
              : const Color(0xFFE2E8F0), // Slate 200
          width: 1,
        ),
      ),
      color: isDark ? const Color(0xFF1E293B) : Colors.white, // Slate 800
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.push('/venues/${venue.id}');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Venue Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageUrl.isNotEmpty)
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholderImage(theme),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                    )
                  else
                    _buildPlaceholderImage(theme),

                  // Sport Type Tag Overlay
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        venue.sportType,
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Card Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Location details
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          venue.address,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(ThemeData theme) {
    return Container(
      color: theme.colorScheme.primary.withOpacity(0.08),
      child: Center(
        child: Icon(
          Icons.image_not_supported_rounded,
          size: 48,
          color: theme.colorScheme.primary.withOpacity(0.3),
        ),
      ),
    );
  }

  String _venueImageUrl(Venue venue) {
    switch (venue.sportType.toLowerCase()) {
      case 'football':
        return 'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?auto=format&fit=crop&w=900&q=80';
      case 'cricket':
        return 'https://images.unsplash.com/photo-1531415074968-036ba1b575da?auto=format&fit=crop&w=900&q=80';
      default:
        return venue.imageUrl ?? '';
    }
  }
}
