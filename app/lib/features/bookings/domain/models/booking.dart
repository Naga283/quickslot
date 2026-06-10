import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../venues/domain/models/slot.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

@freezed
class Booking with _$Booking {
  const factory Booking({
    required String id,
    required String userId,
    required String slotId,
    required DateTime createdAt,
    Slot? slot,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
}
