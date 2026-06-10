import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/repositories/waitlist_repository_impl.dart';
import '../../domain/repositories/waitlist_repository.dart';
import '../../domain/models/waitlist.dart';

part 'waitlist_providers.g.dart';

@riverpod
WaitlistRepository waitlistRepository(WaitlistRepositoryRef ref) {
  final dioClient = ref.watch(dioProvider);
  return WaitlistRepositoryImpl(dioClient);
}

@riverpod
Future<List<Waitlist>> fetchUserWaitlist(FetchUserWaitlistRef ref, String userId) {
  return ref.watch(waitlistRepositoryProvider).getUserWaitlist(userId);
}
