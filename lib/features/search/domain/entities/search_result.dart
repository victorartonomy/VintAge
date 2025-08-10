import 'package:vintage/features/posts/domain/entities/post.dart';
import 'package:vintage/features/profile/domain/entities/profile_user.dart';
import 'package:vintage/features/services/domain/entities/service.dart';
import 'package:vintage/features/shop/domain/entities/product.dart';

class SearchResult {
  final List<ProfileUser> users;
  final List<Post> posts;
  final List<Product> products;
  final List<Service> services;

  SearchResult({
    this.users = const [],
    this.posts = const [],
    this.products = const [],
    this.services = const [],
  });

  bool get isEmpty =>
      users.isEmpty && posts.isEmpty && products.isEmpty && services.isEmpty;
}
