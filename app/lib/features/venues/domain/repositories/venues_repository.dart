import '../models/venue.dart';
import '../models/slot.dart';

abstract class VenuesRepository {
  Future<(List<Venue> venues, int totalCount)> getVenues({
    String? sportType,
    int page = 1,
    int limit = 10,
  });
  Future<Venue> getVenueById(String id);
  Future<List<Slot>> getVenueSlots({required String id, String? date});
}
