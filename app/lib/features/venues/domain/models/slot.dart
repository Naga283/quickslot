import 'package:freezed_annotation/freezed_annotation.dart';

part 'slot.freezed.dart';
part 'slot.g.dart';

enum SlotStatus {
  @JsonValue('AVAILABLE')
  available,
  @JsonValue('BOOKED')
  booked,
}

@freezed
class Slot with _$Slot {
  const factory Slot({
    required String id,
    required String venueId,
    required DateTime date,
    required DateTime startTime,
    required DateTime endTime,
    required SlotStatus status,
  }) = _Slot;

  factory Slot.fromJson(Map<String, dynamic> json) => _$SlotFromJson(json);
}
