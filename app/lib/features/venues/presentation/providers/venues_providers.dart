import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/repositories/venues_repository_impl.dart';
import '../../domain/repositories/venues_repository.dart';
import '../../domain/models/venue.dart';
import '../../domain/models/slot.dart';

part 'venues_providers.g.dart';

@riverpod
VenuesRepository venuesRepository(VenuesRepositoryRef ref) {
  final dioClient = ref.watch(dioProvider);
  return VenuesRepositoryImpl(dioClient);
}

@riverpod
Future<(List<Venue> venues, int totalCount)> fetchVenues(
  FetchVenuesRef ref, {
  String? sportType,
  int page = 1,
  int limit = 10,
}) {
  return ref.watch(venuesRepositoryProvider).getVenues(
        sportType: sportType,
        page: page,
        limit: limit,
      );
}

@riverpod
Future<List<Slot>> fetchVenueSlots(
  FetchVenueSlotsRef ref, {
  required String venueId,
  String? date,
}) {
  return ref.watch(venuesRepositoryProvider).getVenueSlots(
        id: venueId,
        date: date,
      );
}
