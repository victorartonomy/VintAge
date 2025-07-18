import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/posts/domain/entities/post.dart';
import 'package:vintage/features/posts/domain/repos/post_repo.dart';
import 'package:vintage/features/posts/presentation/cubits/post_states.dart';
import 'package:vintage/features/storage/domain/storage_repo.dart';

class PostCubit extends Cubit<PostStates> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;
  PostCubit({required this.postRepo, required this.storageRepo}) : super(PostsInitial());

  // create a new post
  Future<void> createPost(Post post, {String? imagePath, Uint8List? imageBytes}) async {
    String? imageUrl;
    try {
      // handle image upload for mobile platforms (using file path)
      if (imagePath != null) {
        emit(PostsUploading());
        imageUrl = await storageRepo.uploadPostImageMobile(imagePath, post.id);
      }

      // handle image upload for web platforms (using file bytes)
      else if (imageBytes != null) {
        emit(PostsUploading());
        imageUrl = await storageRepo.uploadPostImageWeb(imageBytes, post.id);
      }

      // give imageUrl to Post
      final newPost = post.copyWith(imageUrl: imageUrl);

      // create post in backend
      postRepo.createPost(newPost);

      // re-fetch all posts
      fetchAllPosts();
    }
    catch (e) {
      emit(PostsError("Failed to create post: $e"));
    }
  }

  // fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostsLoaded(posts));
    }
    catch (e) {
      emit(PostsError("Failed to fetch posts: $e"));
    }
  }

  // deleting posts
  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    }
    catch (e) {
      emit(PostsError("Failed to delete post: $e"));
    }
  }

  // toggle likes
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepo.toggleLikePost(postId, userId);
    }
    catch (e) {
      emit(PostsError("Failed to toggle like: $e"));
    }
  }
}