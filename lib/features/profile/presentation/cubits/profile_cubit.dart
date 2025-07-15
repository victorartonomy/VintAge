import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/profile/domain/repos/profile_repo.dart';
import 'package:vintage/features/profile/presentation/cubits/profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates>{
  final ProfileRepository profileRepo;

  ProfileCubit({required this.profileRepo}):super(ProfileInitial());

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

      // update new profile
      final updatedProfile = currentUser.copyWith(newBio: newBio ?? currentUser.bio);

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