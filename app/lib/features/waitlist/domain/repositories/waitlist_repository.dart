import '../models/waitlist.dart';

abstract class WaitlistRepository {
  Future<Waitlist> joinWaitlist({required String userId, required String slotId});
  Future<void> leaveWaitlist(String waitlistId);
  Future<List<Waitlist>> getUserWaitlist(String userId);
}
