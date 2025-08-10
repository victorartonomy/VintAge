import 'package:vintage/features/posts/domain/entities/post.dart';
import 'package:vintage/features/profile/domain/entities/profile_user.dart';
import 'package:vintage/features/services/domain/entities/service.dart';
import 'package:vintage/features/shop/domain/entities/product.dart';
import 'package:vintage/features/search/domain/entities/search_result.dart';

abstract class SearchRepo {
  Future<SearchResult> search(String query);
  Future<List<ProfileUser>> searchUsers(String query);
  Future<List<Post>> searchPosts(String query);
  Future<List<Product>> searchProducts(String query);
  Future<List<Service>> searchServices(String query);
}
