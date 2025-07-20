import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vintage/features/profile/domain/entities/profile_user.dart';
import 'package:vintage/features/profile/domain/repos/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepository{

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {

      // get user document from firestore
      final userDoc = await firebaseFirestore.collection('users').doc(uid).get();

      if(userDoc.exists){
        final userData = userDoc.data();

        if(userData!=null) {
          // fetch followers and following from firebase
          final followers = List<String>.from(userData['followers'] ?? []);
          final following = List<String>.from(userData['following'] ?? []);

          return ProfileUser(
            uid: uid,
            email: userData['email'],
            name: userData['name'],
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl'].toString(),
            followers: followers,
            following: following,
          );
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updateProfile) async {
    try {

      // convert update profile to JSON to store in firebase
      await firebaseFirestore
          .collection('users')
          .doc(updateProfile.uid)
          .update({
        // 'name': updateProfile.name,
        'bio': updateProfile.bio,
        'profileImageUrl': updateProfile.profileImageUrl,
      });

    }

    catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> toggleFollow(String currentUserId, String targetUserId) async {
    try {

      final currentUserDoc = await firebaseFirestore.collection('users').doc(currentUserId).get();
      final targetUserDoc = await firebaseFirestore.collection('users').doc(targetUserId).get();

      if (currentUserDoc.exists && targetUserDoc.exists) {

        final currentUserData = currentUserDoc.data();
        final targetUserData = targetUserDoc.data();

        if (currentUserData != null && targetUserData != null) {
          final List<String> currentFollowing = List<String>.from(currentUserData['following'] ?? []);

          // check if current user is already following the target user
          if (currentFollowing.contains(targetUserId)) {
            // unFollow
            await firebaseFirestore.collection('users').doc(currentUserId).update({'following': FieldValue.arrayRemove([targetUserId])});
            await firebaseFirestore.collection('users').doc(targetUserId).update({'followers': FieldValue.arrayRemove([currentUserId])});
          }

          else {
            // follow
            await firebaseFirestore.collection('users').doc(currentUserId).update({'following': FieldValue.arrayUnion([targetUserId])});
            await firebaseFirestore.collection('users').doc(targetUserId).update({'followers': FieldValue.arrayUnion([currentUserId])});
          }
        }

      }

    } catch (e) {}
  }
  
}