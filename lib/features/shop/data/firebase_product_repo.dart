import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vintage/features/posts/domain/entities/comment.dart';
import 'package:vintage/features/shop/domain/entities/product.dart';
import 'package:vintage/features/shop/domain/repos/product_repo.dart';

class FirebaseProductRepo implements ProductRepo {

  // firestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // store all products in a collection called products
  final CollectionReference productsCollection = FirebaseFirestore.instance
      .collection('products');

  @override
  Future<void> addComment(String productId, Comment comment) {
    // TODO: implement addComment
    throw UnimplementedError();
  }

  @override
  Future<void> createProduct(Product product) async {
    try {
      await productsCollection.doc(product.id).set(product.toJson());
    } catch (e) {
      throw Exception("Failed to create product: $e");
    }
  }

  @override
  Future<void> deleteComment(String productId, String commentId) {
    // TODO: implement deleteComment
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProduct(String productId) async {
    try {
      await productsCollection.doc(productId).delete();
    } catch (e) {
      throw Exception("Failed to delete product: $e");
    }
  }

  @override
  Future<List<Product>> fetchAllProducts() async {
    try {
      // get all products with the most recent products on top
      final productsSnapshot =
          await productsCollection.orderBy('timestamp', descending: true).get();

      // convert each firestore document from JSON to lists of products
      final List<Product> allProducts =
          productsSnapshot.docs
              .map(
                (doc) => Product.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList();

      return allProducts;
    } catch (e) {
      throw Exception("Failed to fetch products: $e");
    }
  }

  @override
  Future<List<Product>> fetchProductsByUserId(String userId) async {
    try {
      // fetch posts snapshot with this uid
      final productsSnapshot =
          await productsCollection.where('uid', isEqualTo: userId).get();

      // convert from JSON to lists of products
      final List<Product> userProducts =
          productsSnapshot.docs
              .map(
                (doc) => Product.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList();

      return userProducts;
    } catch (e) {
      throw Exception("Failed to fetch products: $e");
    }
  }

  @override
  Future<int?> getUserRating(String productId, String userId) async {
    try {
      // get the product document from firestore
      final productDoc = await productsCollection.doc(productId).get();

      // check if doc exists
      if (productDoc.exists) {
        final product = Product.fromJson(
          productDoc.data() as Map<String, dynamic>,
        );
        return product.getUserRating(userId);
      } else {
        throw Exception("Product not found");
      }
    } catch (e) {
      throw Exception("Failed to get user rating: $e");
    }
  }

  @override
  Future<void> rateProduct(String productId, String userId, int rating) async {
    try {
      // Validate rating (1-5)
      if (rating < 1 || rating > 5) {
        throw Exception("Rating must be between 1 and 5");
      }

      // get the product document from firestore
      final productDoc = await productsCollection.doc(productId).get();

      // check if doc exists
      if (productDoc.exists) {
        final product = Product.fromJson(
          productDoc.data() as Map<String, dynamic>,
        );

        // Create a new map with the updated rating
        Map<String, int> updatedUserRatings = Map.from(product.userRatings);
        updatedUserRatings[userId] = rating;

        // update the product document in firestore
        await productsCollection.doc(productId).update({
          'userRatings': updatedUserRatings,
        });
      } else {
        throw Exception("Product not found");
      }
    } catch (e) {
      throw Exception("Failed to rate product: $e");
    }
  }

  @override
  Future<void> toggleLikeProduct(String productId, String userId)  async {
    try {
      // get the product document from firestore
      final productDoc = await productsCollection.doc(productId).get();

      // check if doc exists
      if (productDoc.exists) {
        final product = Product.fromJson(
          productDoc.data() as Map<String, dynamic>,
        );

        // check if user has already liked the product
        if (product.likes.contains(userId)) {
          // remove user from likes
          product.likes.remove(userId);
        } else {
          // add user to likes
          product.likes.add(userId);
        }

        // update the product document in firestore
        await productsCollection.doc(productId).update({
          'likes': product.likes,
        });
      } else {
        throw Exception("Product not found");
      }
    } catch (e) {
      throw Exception("Failed to toggle like: $e");
    }
  }

}