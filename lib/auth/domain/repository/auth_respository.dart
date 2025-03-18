/*
 * Possible auth operations
 */
import 'package:note_app/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  Future<AppUser?> signIn(String email, String password);
  Future<AppUser?> signUp(String name, String email, String password);
  Future<void> logOut();
  Future<AppUser?> getCurrentUser();
}
