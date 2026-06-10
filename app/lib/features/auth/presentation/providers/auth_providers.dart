import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive/hive.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/models/user.dart';

part 'auth_providers.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final dioClient = ref.watch(dioProvider);
  return AuthRepositoryImpl(dioClient);
}

@riverpod
class CurrentUser extends _$CurrentUser {
  static const _userKey = 'current_user';

  Box get _authBox => Hive.box('auth_cache');

  @override
  User? build() {
    final cachedUser = _authBox.get(_userKey);
    if (cachedUser is Map) {
      return User.fromJson(Map<String, dynamic>.from(cachedUser));
    }
    return null;
  }

  Future<void> setUser(User user) async {
    await _authBox.put(_userKey, user.toJson());
    state = user;
  }

  Future<void> logout() async {
    await _authBox.delete(_userKey);
    await Hive.box('bookings_cache').clear();
    state = null;
  }
}
