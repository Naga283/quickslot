import '../models/booking.dart';

abstract class BookingsRepository {
  Future<Booking> createBooking({required String userId, required String slotId});
  Future<void> cancelBooking(String bookingId);
  Future<List<Booking>> getUserBookings(String userId);
}
