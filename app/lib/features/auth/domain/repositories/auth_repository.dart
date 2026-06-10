import '../models/user.dart';

abstract class AuthRepository {
  Future<User> createUser({required String name, required String email});
  Future<User> getUserById(String id);
}
