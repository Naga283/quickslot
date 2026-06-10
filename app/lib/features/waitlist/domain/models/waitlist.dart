import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../venues/domain/models/slot.dart';

part 'waitlist.freezed.dart';
part 'waitlist.g.dart';

@freezed
class Waitlist with _$Waitlist {
  const factory Waitlist({
    required String id,
    required String userId,
    required String slotId,
    required DateTime createdAt,
    Slot? slot,
  }) = _Waitlist;

  factory Waitlist.fromJson(Map<String, dynamic> json) => _$WaitlistFromJson(json);
}
