import 'package:vintage/features/authentication/domain/entities/app_user.dart';
import 'package:vintage/features/authentication/domain/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  @override
  Future<AppUser?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<AppUser?> loginWithEmailAndPassword(String email, String password) {
    // TODO: implement loginWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<AppUser?> registerWithEmailAndPassword(String email, String password, String name) {
    // TODO: implement registerWithEmailAndPassword
    throw UnimplementedError();
  }
  
}