import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../bookings/presentation/providers/bookings_providers.dart';
import '../../../bookings/domain/repositories/bookings_repository.dart';
import '../../../waitlist/presentation/providers/waitlist_providers.dart';
import '../providers/venues_providers.dart';
import '../../domain/models/slot.dart';
import '../../../../core/services/notification_service.dart';
import '../../domain/models/venue.dart';

// Local view providers
final selectedDetailDateProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);
final selectedTimeFilterProvider = StateProvider<String>((ref) => 'all');
final slotActionLoadingProvider = StateProvider<Set<String>>(
  (ref) => <String>{},
);

class VenueDetailView extends ConsumerWidget {
  final String venueId;

  const VenueDetailView({super.key, required this.venueId});

  String _formatDateString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatHour(DateTime time) {
    final hour = time.hour;
    final amPm = hour >= 12 ? 'PM' : 'AM';
    final formattedHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$formattedHour:00 $amPm';
  }

  List<Slot> _filterSlots(List<Slot> slots, String filter) {
    if (filter == 'all') return slots;
    return slots.where((slot) {
      final hour = slot.startTime.hour;
      if (filter == 'morning') {
        return hour >= 6 && hour < 12;
      } else if (filter == 'afternoon') {
        return hour >= 12 && hour < 17;
      } else if (filter == 'evening') {
        return hour >= 17 && hour < 22;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedDate = ref.watch(selectedDetailDateProvider);
    final timeFilter = ref.watch(selectedTimeFilterProvider);
    final loadingSlotIds = ref.watch(slotActionLoadingProvider);

    // Watch Venue Details
    final venueFuture = ref.watch(fetchVenueByIdProvider(venueId));

    // Watch Slots (query format YYYY-MM-DD)
    final slotsFuture = ref.watch(
      fetchVenueSlotsProvider(
        venueId: venueId,
        date: _formatDateString(selectedDate),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: venueFuture.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
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
                    'Failed to load venue',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(err.toString(), textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () =>
                        ref.invalidate(fetchVenueByIdProvider(venueId)),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          ),
          data: (venue) {
            final imageUrl = _venueImageUrl(venue);

            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                // Custom App Bar with image overlay
                SliverAppBar(
                  expandedHeight: 220,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      venue.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 4,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (imageUrl.isNotEmpty)
                          Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.1,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_not_supported_rounded,
                                      size: 56,
                                    ),
                                  ),
                                ),
                          )
                        else
                          Container(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                          ),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black87],
                              stops: [0.6, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  leading: IconButton(
                    icon: const CircleAvatar(
                      backgroundColor: Colors.black45,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => context.pop(),
                  ),
                ),

                // Info Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.15,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.3,
                                  ),
                                ),
                              ),
                              child: Text(
                                venue.sportType,
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: theme.colorScheme.secondary,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                venue.address,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Divider(),
                      ],
                    ),
                  ),
                ),

                // Horizontal Timeline Date Picker
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Select Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.calendar_today_rounded),
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 30),
                                  ),
                                );
                                if (date != null) {
                                  ref
                                          .read(
                                            selectedDetailDateProvider.notifier,
                                          )
                                          .state =
                                      date;
                                }
                              },
                              tooltip: 'Open Calendar',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 14-day horizontal picker
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: 14,
                          itemBuilder: (context, index) {
                            final date = DateTime.now().add(
                              Duration(days: index),
                            );
                            final isSelected = DateUtils.isSameDay(
                              date,
                              selectedDate,
                            );

                            final dayName = _getWeekAbbreviation(date);
                            final dayNum = date.day.toString();

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              child: ChoiceChip(
                                label: SizedBox(
                                  width: 36,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        dayName,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isSelected
                                              ? theme.colorScheme.onPrimary
                                              : (isDark
                                                    ? Colors.white54
                                                    : Colors.black54),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        dayNum,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? theme.colorScheme.onPrimary
                                              : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (val) {
                                  if (val) {
                                    ref
                                            .read(
                                              selectedDetailDateProvider
                                                  .notifier,
                                            )
                                            .state =
                                        date;
                                  }
                                },
                                showCheckmark: false,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                // Time Filters
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Filter Time',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildTimeFilterChip(
                                ref,
                                'All',
                                'all',
                                timeFilter,
                              ),
                              _buildTimeFilterChip(
                                ref,
                                'Morning (6am - 12pm)',
                                'morning',
                                timeFilter,
                              ),
                              _buildTimeFilterChip(
                                ref,
                                'Afternoon (12pm - 5pm)',
                                'afternoon',
                                timeFilter,
                              ),
                              _buildTimeFilterChip(
                                ref,
                                'Evening (5pm - 10pm)',
                                'evening',
                                timeFilter,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                      ],
                    ),
                  ),
                ),
              ],

              // Grid list containing slots
              body: slotsFuture.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'Failed to load slots: $err',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                data: (allSlots) {
                  final filteredSlots = _filterSlots(allSlots, timeFilter);

                  if (filteredSlots.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: 48,
                              color: theme.colorScheme.primary.withOpacity(0.3),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No slots available matching criteria',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 16.0,
                        ),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 130,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 2.3,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final slot = filteredSlots[index];
                            final isAvailable =
                                slot.status == SlotStatus.available;
                            final isSlotLoading = loadingSlotIds.contains(
                              slot.id,
                            );

                            final slotBgColor = isAvailable
                                ? const Color(0xFF10B981).withOpacity(
                                    0.12,
                                  ) // Green opacity
                                : const Color(
                                    0xFFEF4444,
                                  ).withOpacity(0.12); // Red opacity

                            final slotBorderColor = isAvailable
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444);

                            return Container(
                              decoration: BoxDecoration(
                                color: slotBgColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: slotBorderColor,
                                  width: 1.5,
                                ),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: isSlotLoading
                                    ? null
                                    : () => _handleSlotInteraction(
                                        context,
                                        ref,
                                        slot,
                                        isAvailable,
                                        venue,
                                      ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (isSlotLoading)
                                      SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: slotBorderColor,
                                        ),
                                      )
                                    else ...[
                                      Text(
                                        _formatHour(slot.startTime),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black87,
                                          fontSize: 13,
                                        ),
                                      ),
                                      if (!isAvailable) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          'Join Waitlist',
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.red[200]
                                                : Colors.red[700],
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ],
                                ),
                              ),
                            );
                          }, childCount: filteredSlots.length),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimeFilterChip(
    WidgetRef ref,
    String label,
    String value,
    String currentValue,
  ) {
    final isSelected = value == currentValue;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (val) {
          if (val) {
            ref.read(selectedTimeFilterProvider.notifier).state = value;
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String _getWeekAbbreviation(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }

  String _venueImageUrl(Venue venue) {
    switch (venue.sportType.toLowerCase()) {
      case 'football':
        return 'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?auto=format&fit=crop&w=1200&q=85';
      case 'cricket':
        return 'https://images.unsplash.com/photo-1531415074968-036ba1b575da?auto=format&fit=crop&w=1200&q=85';
      default:
        return venue.imageUrl ?? '';
    }
  }

  void _handleSlotInteraction(
    BuildContext context,
    WidgetRef ref,
    Slot slot,
    bool isAvailable,
    Venue venue,
  ) {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    if (isAvailable) {
      // Prompt Booking
      showDialog(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          title: const Text('Confirm Booking'),
          content: Text(
            'Do you want to book this slot on ${_formatHour(slot.startTime)}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(dialogCtx);
                _executeBooking(context, ref, currentUser.id, slot, venue);
              },
              child: const Text('Book Now'),
            ),
          ],
        ),
      );
    } else {
      // Prompt Waitlist
      showDialog(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          title: const Text('Slot Booked'),
          content: const Text(
            'This slot is already booked. Would you like to join the waitlist for it? You will be auto-promoted if it is cancelled.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                _executeWaitlistJoin(context, ref, currentUser.id, slot.id);
              },
              child: const Text('Join Waitlist'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _executeBooking(
    BuildContext context,
    WidgetRef ref,
    String userId,
    Slot slot,
    Venue venue,
  ) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final selectedDateStr = _formatDateString(
      ref.read(selectedDetailDateProvider),
    );
    final loadingNotifier = ref.read(slotActionLoadingProvider.notifier);
    loadingNotifier.state = {...loadingNotifier.state, slot.id};
    try {
      // Execute booking creation via Repository
      final booking = await ref
          .read(bookingsRepositoryProvider)
          .createBooking(userId: userId, slotId: slot.id);

      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Slot booked successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Trigger local notifications
      try {
        final notificationService = ref.read(
          notificationServiceProvider.notifier,
        );

        // Instant notification
        await notificationService.showNotification(
          id: slot.id.hashCode,
          title: 'Booking Confirmed',
          body:
              'You have booked a slot at ${venue.name} for ${_formatHour(slot.startTime)}.',
        );

        // Scheduled 1-hour reminder notification
        final reminderTime = slot.startTime.subtract(const Duration(hours: 1));
        if (reminderTime.isAfter(DateTime.now())) {
          await notificationService.scheduleNotification(
            id: slot.id.hashCode + 1,
            title: 'Upcoming Booking Reminder',
            body: 'Your booking at ${venue.name} starts in 1 hour.',
            scheduledDate: reminderTime,
          );
        }
      } catch (err) {
        debugPrint(
          '[Notification] Error triggering booking notifications: $err',
        );
      }

      // Invalidate slots provider to refetch and show updated BOOKED state
      ref.invalidate(
        fetchVenueSlotsProvider(venueId: venueId, date: selectedDateStr),
      );

      // Navigate to Booking Pass screen
      if (context.mounted) {
        context.push(
          '/booking-pass',
          extra: {
            'bookingId': booking.id,
            'venueName': venue.name,
            'sportType': venue.sportType,
            'address': venue.address,
            'date': slot.date,
            'startTime': slot.startTime,
            'endTime': slot.endTime,
          },
        );
      }
    } catch (e) {
      final isConflict = e is BookingConflictException;
      final message = isConflict
          ? 'This slot was booked by another user.'
          : e.toString().replaceAll('Exception:', '').trim();

      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );

      // Refresh slot data automatically on conflict or other state changes
      ref.invalidate(
        fetchVenueSlotsProvider(venueId: venueId, date: selectedDateStr),
      );
    } finally {
      loadingNotifier.state = {...loadingNotifier.state}..remove(slot.id);
    }
  }

  Future<void> _executeWaitlistJoin(
    BuildContext context,
    WidgetRef ref,
    String userId,
    String slotId,
  ) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final selectedDateStr = _formatDateString(
      ref.read(selectedDetailDateProvider),
    );
    final loadingNotifier = ref.read(slotActionLoadingProvider.notifier);
    loadingNotifier.state = {...loadingNotifier.state, slotId};
    try {
      await ref
          .read(waitlistRepositoryProvider)
          .joinWaitlist(userId: userId, slotId: slotId);

      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Successfully joined waitlist!'),
          backgroundColor: Colors.blue,
        ),
      );

      ref.invalidate(
        fetchVenueSlotsProvider(venueId: venueId, date: selectedDateStr),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception:', '').trim()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      loadingNotifier.state = {...loadingNotifier.state}..remove(slotId);
    }
  }
}
