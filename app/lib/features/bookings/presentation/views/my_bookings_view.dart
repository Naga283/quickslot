import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../venues/presentation/providers/venues_providers.dart';
import '../providers/bookings_providers.dart';
import '../../domain/models/booking.dart';
import '../../../../core/services/notification_service.dart';

class MyBookingsView extends ConsumerStatefulWidget {
  const MyBookingsView({super.key});

  @override
  ConsumerState<MyBookingsView> createState() => _MyBookingsViewState();
}

class _MyBookingsViewState extends ConsumerState<MyBookingsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        ref.read(myBookingsProvider.notifier).fetchBookings(user.id);
      }
    });
  }

  String _formatDateTime(DateTime start, DateTime end) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final weekday = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    final dateStr = '${weekday[start.weekday - 1]}, ${months[start.month - 1]} ${start.day}';
    
    final startHour = start.hour;
    final startAmPm = startHour >= 12 ? 'PM' : 'AM';
    final formattedStartHour = startHour > 12 ? startHour - 12 : (startHour == 0 ? 12 : startHour);
    
    final endHour = end.hour;
    final endAmPm = endHour >= 12 ? 'PM' : 'AM';
    final formattedEndHour = endHour > 12 ? endHour - 12 : (endHour == 0 ? 12 : endHour);
    
    return '$dateStr • $formattedStartHour:00 $startAmPm - $formattedEndHour:00 $endAmPm';
  }

  Future<void> _cancelBooking(BuildContext context, Booking booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text(
          'Are you sure you want to cancel this booking? This will make the slot available to other users or auto-promote someone from the waitlist.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('No, Keep It'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    // Show progress loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await ref.read(myBookingsProvider.notifier).cancel(booking.id);
      
      if (booking.slot != null) {
        try {
          await ref.read(notificationServiceProvider.notifier).cancelNotification(booking.slot!.id.hashCode + 1);
        } catch (err) {
          debugPrint('[Notification] Error cancelling reminder: $err');
        }
      }

      if (!context.mounted) return;
      Navigator.pop(context); // Pop loading indicator
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Booking cancelled successfully.'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Also invalidate slots provider to refresh slots on Detail Screen if user goes back
      ref.invalidate(fetchVenueSlotsProvider);
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); // Pop loading indicator
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception:', '').trim()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final user = ref.watch(currentUserProvider);
    final state = ref.watch(myBookingsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Bookings',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Upcoming tab content
            _buildBookingsTab(
              theme: theme,
              isDark: isDark,
              bookings: state.upcoming,
              isLoading: state.isLoading,
              errorMessage: state.errorMessage,
              isUpcoming: true,
              userId: user?.id ?? '',
            ),
            // Cancelled tab content
            _buildBookingsTab(
              theme: theme,
              isDark: isDark,
              bookings: state.cancelled,
              isLoading: state.isLoading,
              errorMessage: state.errorMessage,
              isUpcoming: false,
              userId: user?.id ?? '',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsTab({
    required ThemeData theme,
    required bool isDark,
    required List<Booking> bookings,
    required bool isLoading,
    required String? errorMessage,
    required bool isUpcoming,
    required String userId,
  }) {
    if (isLoading && bookings.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null && bookings.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Failed to load bookings',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(errorMessage, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                if (userId.isNotEmpty) {
                  ref.read(myBookingsProvider.notifier).fetchBookings(userId);
                }
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (userId.isNotEmpty) {
          await ref.read(myBookingsProvider.notifier).fetchBookings(userId);
        }
      },
      child: bookings.isEmpty
          ? ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isUpcoming ? Icons.calendar_today_outlined : Icons.cancel_outlined,
                            size: 64,
                            color: theme.colorScheme.primary.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isUpcoming ? 'No upcoming bookings' : 'No cancelled bookings',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isUpcoming
                                ? 'Browse venues and book a slot to get started.'
                                : 'Bookings cancelled during this session will appear here.',
                            textAlign: TextAlign.center,
                          ),
                          if (isUpcoming) ...[
                            const SizedBox(height: 24),
                            FilledButton.icon(
                              onPressed: () => context.pop(),
                              icon: const Icon(Icons.search_rounded),
                              label: const Text('Find Venues'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final slot = booking.slot;
                final venue = slot?.venue;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isDark
                          ? const Color(0xFF334155).withOpacity(0.5)
                          : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Venue and Sport Badge
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    venue?.name ?? 'Unknown Venue',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    venue?.sportType ?? 'Sport',
                                    style: TextStyle(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!isUpcoming)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.error.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Cancelled',
                                  style: TextStyle(
                                    color: theme.colorScheme.error,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),

                        // Date & Time
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded, size: 16, color: theme.colorScheme.secondary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                slot != null
                                    ? _formatDateTime(slot.startTime, slot.endTime)
                                    : 'Date & Time Unavailable',
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Address
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 16, color: theme.colorScheme.secondary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                venue?.address ?? 'Address Unavailable',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        // Action Buttons
                        if (isUpcoming) ...[
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    if (slot != null) {
                                      context.push('/booking-pass', extra: {
                                        'bookingId': booking.id,
                                        'venueName': venue?.name ?? 'Unknown Venue',
                                        'sportType': venue?.sportType ?? 'Sport',
                                        'address': venue?.address ?? 'Address Unavailable',
                                        'date': slot.date,
                                        'startTime': slot.startTime,
                                        'endTime': slot.endTime,
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.qr_code_2_rounded, size: 18),
                                  label: const Text('View Pass'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: theme.colorScheme.primary,
                                    side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.5)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _cancelBooking(context, booking),
                                  icon: const Icon(Icons.cancel_outlined, size: 18),
                                  label: const Text('Cancel'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: theme.colorScheme.error,
                                    side: BorderSide(color: theme.colorScheme.error.withValues(alpha: 0.5)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
