import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/profile/domain/repos/profile_repo.dart';
import 'package:vintage/features/profile/presentation/cubits/profile_states.dart';
import 'package:vintage/features/storage/domain/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileStates>{
  final ProfileRepository profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({required this.profileRepo, required this.storageRepo}):super(ProfileInitial());

  // fetch user profile using repo
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);

      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("User not found"));
      }
    }
    catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // update bio and profile picture
  Future<void> updateProfile({
    required String uid,
    String? newBio,
    Uint8List? imageWebBytes,
    String? imageMobilePath,
  }) async {
    emit(ProfileLoading());

    try {

      // fetch current user
      final currentUser = await profileRepo.fetchUserProfile(uid);

      if(currentUser == null) {
        emit(ProfileError("Failed to fetch user"));
        return;
      }

      // profile picture update
      String? imageDownloadUrl;
      // ensure there is a image
      if (imageWebBytes != null || imageMobilePath != null) {
        // for mobile
        if (imageMobilePath != null) {
          // upload
          imageDownloadUrl = await storageRepo.uploadProfileImageMobile(imageMobilePath, uid);
        }
        // for web
        else if (imageWebBytes != null) {
          // upload
          imageDownloadUrl = await storageRepo.uploadProfileImageWeb(imageWebBytes, uid);
        }

        if (imageDownloadUrl == null) {
          emit(ProfileError("Failed to upload image"));
          return;
        }
      }

      // update new profile
      final updatedProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl,
      );


      // update in repo
      await profileRepo.updateProfile(updatedProfile);

      // refresh profile
      await fetchUserProfile(uid);

    }
    catch (e) {
      emit(ProfileError("Error updating profile: $e"));
    }
  }
}