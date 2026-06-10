import 'package:dio/dio.dart';
import '../../domain/models/booking.dart';
import '../../domain/repositories/bookings_repository.dart';

class BookingsRepositoryImpl implements BookingsRepository {
  final Dio _dio;

  BookingsRepositoryImpl(this._dio);

  @override
  Future<Booking> createBooking({required String userId, required String slotId}) async {
    try {
      final response = await _dio.post(
        '/bookings',
        data: {
          'userId': userId,
          'slotId': slotId,
        },
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return Booking.fromJson(data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to book slot');
    }
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _dio.delete('/bookings/$bookingId');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to cancel booking');
    }
  }

  @override
  Future<List<Booking>> getUserBookings(String userId) async {
    try {
      final response = await _dio.get('/users/$userId/bookings');
      final listData = response.data['data'] as List;
      return listData.map((e) => Booking.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch user bookings');
    }
  }
}
