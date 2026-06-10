import 'package:riverpod_annotation/riverpod_annotation.dart';
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
  @override
  User? build() {
    return null;
  }

  void setUser(User user) {
    state = user;
  }

  void logout() {
    state = null;
  }
}
