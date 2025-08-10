import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vintage/features/posts/domain/entities/post.dart';
import 'package:vintage/features/profile/domain/entities/profile_user.dart';
import 'package:vintage/features/search/domain/entities/search_result.dart';
import 'package:vintage/features/services/domain/entities/service.dart';
import 'package:vintage/features/shop/domain/entities/product.dart';
import 'package:vintage/features/search/domain/search_repo.dart';

class FirebaseSearchRepo implements SearchRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<SearchResult> search(String query) async {
    try {
      final users = await searchUsers(query);
      final posts = await searchPosts(query);
      final products = await searchProducts(query);
      final services = await searchServices(query);

      return SearchResult(
        users: users,
        posts: posts,
        products: products,
        services: services,
      );
    } catch (e) {
      throw Exception("Error performing search: $e");
    }
  }

  @override
  Future<List<ProfileUser>> searchUsers(String query) async {
    try {
      final result =
          await _firestore
              .collection("users")
              .where('name', isGreaterThanOrEqualTo: query)
              .where('name', isLessThanOrEqualTo: '$query\uf8ff')
              .get();
      return result.docs
          .map((doc) => ProfileUser.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception("Error searching users");
    }
  }

  @override
  Future<List<Post>> searchPosts(String query) async {
    try {
      final result =
          await _firestore
              .collection("posts")
              .where('title', isGreaterThanOrEqualTo: query)
              .where('title', isLessThanOrEqualTo: '$query\uf8ff')
              .get();
      return result.docs.map((doc) => Post.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception("Error searching posts");
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    try {
      final result =
          await _firestore
              .collection("products")
              .where('title', isGreaterThanOrEqualTo: query)
              .where('title', isLessThanOrEqualTo: '$query\uf8ff')
              .get();
      return result.docs.map((doc) => Product.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception("Error searching products");
    }
  }

  @override
  Future<List<Service>> searchServices(String query) async {
    try {
      final result =
          await _firestore
              .collection("services")
              .where('title', isGreaterThanOrEqualTo: query)
              .where('title', isLessThanOrEqualTo: '$query\uf8ff')
              .get();
      return result.docs.map((doc) => Service.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception("Error searching services");
    }
  }
}
