import '../models/booking.dart';

abstract class BookingsRepository {
  Future<Booking> createBooking({required String userId, required String slotId});
  Future<void> cancelBooking(String bookingId);
  Future<List<Booking>> getUserBookings(String userId);
}

class BookingConflictException implements Exception {
  final String message;
  BookingConflictException([this.message = 'This slot was booked by another user.']);

  @override
  String toString() => message;
}
