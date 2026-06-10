import '../models/user.dart';

abstract class AuthRepository {
  Future<User> createUser({required String name, required String email});
  Future<User> login({required String username, required String password});
  Future<User> getUserById(String id);
}
