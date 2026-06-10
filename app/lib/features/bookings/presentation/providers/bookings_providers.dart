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
