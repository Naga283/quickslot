import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/repositories/bookings_repository_impl.dart';
import '../../domain/repositories/bookings_repository.dart';
import '../../domain/models/booking.dart';

part 'bookings_providers.g.dart';

@riverpod
BookingsRepository bookingsRepository(BookingsRepositoryRef ref) {
  final dioClient = ref.watch(dioProvider);
  return BookingsRepositoryImpl(dioClient);
}

@riverpod
Future<List<Booking>> fetchUserBookings(FetchUserBookingsRef ref, String userId) {
  return ref.watch(bookingsRepositoryProvider).getUserBookings(userId);
}

class MyBookingsState {
  final List<Booking> upcoming;
  final List<Booking> cancelled;
  final bool isLoading;
  final String? errorMessage;

  const MyBookingsState({
    required this.upcoming,
    required this.cancelled,
    required this.isLoading,
    this.errorMessage,
  });

  MyBookingsState copyWith({
    List<Booking>? upcoming,
    List<Booking>? cancelled,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MyBookingsState(
      upcoming: upcoming ?? this.upcoming,
      cancelled: cancelled ?? this.cancelled,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

@riverpod
class MyBookings extends _$MyBookings {
  @override
  MyBookingsState build() {
    return const MyBookingsState(
      upcoming: [],
      cancelled: [],
      isLoading: false,
    );
  }

  Future<void> fetchBookings(String userId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = ref.read(bookingsRepositoryProvider);
      final bookings = await repo.getUserBookings(userId);
      state = state.copyWith(
        upcoming: bookings,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception:', '').trim(),
      );
    }
  }

  Future<void> cancel(String bookingId) async {
    try {
      final repo = ref.read(bookingsRepositoryProvider);
      await repo.cancelBooking(bookingId);
      
      // Find the booking in upcoming list to move to cancelled list
      final index = state.upcoming.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        final booking = state.upcoming[index];
        final updatedUpcoming = List<Booking>.from(state.upcoming)..removeAt(index);
        final updatedCancelled = List<Booking>.from(state.cancelled)..insert(0, booking);
        
        state = state.copyWith(
          upcoming: updatedUpcoming,
          cancelled: updatedCancelled,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
