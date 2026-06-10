import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue.freezed.dart';
part 'venue.g.dart';

@freezed
class Venue with _$Venue {
  const factory Venue({
    required String id,
    required String name,
    required String sportType,
    required String address,
    String? imageUrl,
  }) = _Venue;

  factory Venue.fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);
}
