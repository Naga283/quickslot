import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import '../../domain/models/booking.dart';
import '../../domain/repositories/bookings_repository.dart';

class BookingsRepositoryImpl implements BookingsRepository {
  final Dio _dio;
  final Box _box;

  BookingsRepositoryImpl(this._dio) : _box = Hive.box('bookings_cache');

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
      
      // Invalidate bookings cache for this user
      await _box.delete('bookings_user_$userId');

      return Booking.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw BookingConflictException(e.response?.data['message'] ?? 'This slot was booked by another user.');
      }
      throw Exception(e.response?.data['message'] ?? 'Failed to book slot');
    }
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _dio.delete('/bookings/$bookingId');
      // Invalidate cache (entire user bookings cache will be overwritten on next fetch)
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to cancel booking');
    }
  }

  @override
  Future<List<Booking>> getUserBookings(String userId) async {
    final cacheKey = 'bookings_user_$userId';
    try {
      final response = await _dio.get('/users/$userId/bookings');
      final listData = response.data['data'] as List;

      // Cache raw json payload
      await _box.put(cacheKey, json.encode(listData));

      return listData.map((e) => Booking.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      final cachedData = _box.get(cacheKey);
      if (cachedData != null) {
        final decoded = json.decode(cachedData as String) as List;
        return decoded.map((e) => Booking.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch user bookings');
    }
  }
}
