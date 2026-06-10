import 'package:dio/dio.dart';
import '../../domain/models/waitlist.dart';
import '../../domain/repositories/waitlist_repository.dart';

class WaitlistRepositoryImpl implements WaitlistRepository {
  final Dio _dio;

  WaitlistRepositoryImpl(this._dio);

  @override
  Future<Waitlist> joinWaitlist({required String userId, required String slotId}) async {
    try {
      final response = await _dio.post(
        '/waitlists',
        data: {
          'userId': userId,
          'slotId': slotId,
        },
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return Waitlist.fromJson(data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to join waitlist');
    }
  }

  @override
  Future<void> leaveWaitlist(String waitlistId) async {
    try {
      await _dio.delete('/waitlists/$waitlistId');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to leave waitlist');
    }
  }

  @override
  Future<List<Waitlist>> getUserWaitlist(String userId) async {
    try {
      final response = await _dio.get(
        '/waitlists',
        queryParameters: {'userId': userId},
      );
      final listData = response.data['data'] as List;
      return listData.map((e) => Waitlist.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch waitlist');
    }
  }
}
