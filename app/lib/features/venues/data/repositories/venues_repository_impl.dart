import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import '../../domain/models/venue.dart';
import '../../domain/models/slot.dart';
import '../../domain/repositories/venues_repository.dart';

class VenuesRepositoryImpl implements VenuesRepository {
  final Dio _dio;
  final Box _box;

  VenuesRepositoryImpl(this._dio) : _box = Hive.box('venues_cache');

  @override
  Future<(List<Venue> venues, int totalCount)> getVenues({
    String? sportType,
    int page = 1,
    int limit = 10,
  }) async {
    final cacheKey = 'venues_list_type_${sportType ?? 'all'}_page_${page}_limit_$limit';
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

      // Cache raw json payload
      await _box.put(cacheKey, json.encode({
        'venues': listData,
        'total': total,
      }));

      return (venues, total);
    } on DioException catch (e) {
      final cachedData = _box.get(cacheKey);
      if (cachedData != null) {
        final decoded = json.decode(cachedData as String) as Map<String, dynamic>;
        final venuesList = decoded['venues'] as List;
        final venues = venuesList.map((e) => Venue.fromJson(e as Map<String, dynamic>)).toList();
        final total = decoded['total'] as int;
        return (venues, total);
      }
      throw Exception(e.response?.data['message'] ?? 'Failed to load venues');
    }
  }

  @override
  Future<Venue> getVenueById(String id) async {
    final cacheKey = 'venue_id_$id';
    try {
      final response = await _dio.get('/venues/$id');
      final data = response.data['data'] as Map<String, dynamic>;

      await _box.put(cacheKey, json.encode(data));

      return Venue.fromJson(data);
    } on DioException catch (e) {
      final cachedData = _box.get(cacheKey);
      if (cachedData != null) {
        final decoded = json.decode(cachedData as String) as Map<String, dynamic>;
        return Venue.fromJson(decoded);
      }
      throw Exception(e.response?.data['message'] ?? 'Failed to load venue');
    }
  }

  @override
  Future<List<Slot>> getVenueSlots({required String id, String? date}) async {
    final cacheKey = 'slots_venue_${id}_date_${date ?? 'all'}';
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

      await _box.put(cacheKey, json.encode(listData));

      return listData.map((e) => Slot.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      final cachedData = _box.get(cacheKey);
      if (cachedData != null) {
        final decoded = json.decode(cachedData as String) as List;
        return decoded.map((e) => Slot.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception(e.response?.data['message'] ?? 'Failed to load slots');
    }
  }
}
