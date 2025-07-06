/*

Auth Cubit: State Management

 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/authentication/domain/entities/app_user.dart';
import 'package:vintage/features/authentication/domain/repos/auth_repo.dart';
import 'package:vintage/features/authentication/presentation/cubits/auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AppUser? _currentUser;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  // check if user is logged in
  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  // get current user
  AppUser? get currentUser => _currentUser;

  // login with email and password
  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailAndPassword(email, password);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  // register with email and password
  Future<void> register(String email, String password, String name) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.registerWithEmailAndPassword(email, password, name);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  // logout
  Future<void> logout() async {
    authRepo.logout();
    emit(Unauthenticated());
  }
}