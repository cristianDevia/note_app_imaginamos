import 'package:note_app/auth/domain/entities/app_user.dart';
import 'package:note_app/auth/domain/repository/auth_respository.dart';

class FirebaseAuthRepository implements AuthRepository {
  @override
  Future<AppUser?> signIn(String email, String password) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<AppUser?> signUp(String name, String email, String password) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<AppUser?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<void> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }
}
