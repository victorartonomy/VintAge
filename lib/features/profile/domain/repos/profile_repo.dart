/*

Profile Repository

 */

import 'package:vintage/features/profile/domain/entities/profile_user.dart';

abstract class ProfileRepository {
  Future<ProfileUser?> fetchUserProfile(String uid);
  Future<void> updateProfile(ProfileUser updateProfile);
}