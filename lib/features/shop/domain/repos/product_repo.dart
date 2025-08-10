import 'package:vintage/features/shop/domain/entities/product.dart';

import '../../../posts/domain/entities/comment.dart';

abstract class ProductRepo {
  Future<List<Product>> fetchAllProducts();
  Future<void> createProduct(Product product);
  Future<void> deleteProduct(String productId);
  Future<List<Product>> fetchProductsByUserId(String userId);
  Future<void> toggleLikeProduct(String productId, String userId);
  Future<void> addComment(String productId, Comment comment);
  Future<void> deleteComment(String productId, String commentId);
  Future<void> rateProduct(String productId, String userId, int rating);
  Future<int?> getUserRating(String productId, String userId);
}