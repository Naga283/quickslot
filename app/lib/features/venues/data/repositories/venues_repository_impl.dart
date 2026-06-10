import 'package:dio/dio.dart';
import '../../domain/models/venue.dart';
import '../../domain/models/slot.dart';
import '../../domain/repositories/venues_repository.dart';

class VenuesRepositoryImpl implements VenuesRepository {
  final Dio _dio;

  VenuesRepositoryImpl(this._dio);

  @override
  Future<(List<Venue> venues, int totalCount)> getVenues({
    String? sportType,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (sportType != null) {
        queryParams['sportType'] = sportType;
      }

      final response = await _dio.get(
        '/venues',
        queryParameters: queryParams,
      );
      final listData = response.data['data'] as List;
      final venues = listData.map((e) => Venue.fromJson(e as Map<String, dynamic>)).toList();
      final total = response.data['meta']['total'] as int;
      return (venues, total);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load venues');
    }
  }

  @override
  Future<Venue> getVenueById(String id) async {
    try {
      final response = await _dio.get('/venues/$id');
      final data = response.data['data'] as Map<String, dynamic>;
      return Venue.fromJson(data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load venue');
    }
  }

  @override
  Future<List<Slot>> getVenueSlots({required String id, String? date}) async {
    try {
      final queryParams = <String, String>{};
      if (date != null) {
        queryParams['date'] = date;
      }

      final response = await _dio.get(
        '/venues/$id/slots',
        queryParameters: queryParams,
      );
      final listData = response.data['data'] as List;
      return listData.map((e) => Slot.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load slots');
    }
  }
}
