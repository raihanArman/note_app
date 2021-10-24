import 'package:note_app/models/models.dart';
import 'package:note_app/repositories/base_repository.dart';

abstract class BaseAuthRepository extends BaseRepository {
  Future<User> loginAnonymously();
  Future<User> signupWithEmaiLAndPassword(
      {required String email, required String password});
  Future<User> loginWithEmaiLAndPassword(
      {required String email, required String password});
  Future<User> logout();
  Future<User?> getCurrentUser();
  Future<bool> isAnonymous();
}
