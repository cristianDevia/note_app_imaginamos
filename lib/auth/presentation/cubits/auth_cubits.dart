/*
* Auth cubit state managment
*/

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/auth/domain/entities/app_user.dart';
import 'package:note_app/auth/domain/repository/auth_respository.dart';
import 'package:note_app/auth/presentation/cubits/auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepo;
  AppUser? _currentUser;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  //Check user
  void checkUser() async {
    final AppUser? user = await authRepo.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(UnAuthenticated());
    }
  }

  // get current user
  AppUser? get currentUser => _currentUser;

  // login
  Future<void> signin(String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.signIn(email, password);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  // register
  Future<void> signUp(String name, String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.signUp(name, email, password);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  //logout
  Future<void> logOut() async {
    authRepo.logOut();
    emit(UnAuthenticated());
  }
}
