import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vintage/features/posts/domain/entities/post.dart';
import 'package:vintage/features/posts/domain/repos/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // store all the posts in a collection called posts
  final CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("Failed to create post: $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await postsCollection.doc(postId).delete();
    } catch (e) {
      throw Exception(("Failed to delete post: $e"));
    }
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      // get all posts with the most recent posts on top
      final postsSnapshot = await postsCollection.orderBy('timestamp', descending: true).get();

      // convert each firestore document from JSON to lists of Posts
      final List<Post> allPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return allPosts;
    } catch (e) {
      throw Exception("Failed to fetch posts: $e");
    }
  }

  @override
  Future<List<Post>> fetchPostsByUserId(String userId) async {
    try {

      // fetch posts snapshot with this uid
      final postsSnapshot = await postsCollection.where('userid', isEqualTo: userId).get();

      // convert from JSON to lists of posts
      final userPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return userPosts;

    } catch (e) {
      throw Exception("Failed to fetch posts: $e");
    }
  }
  
}