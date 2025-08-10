import 'package:vintage/features/shop/domain/entities/product.dart';

abstract class ProductStates {}

// initial
class ProductInitial extends ProductStates {}

// loading
class ProductLoading extends ProductStates {}

// uploading...
class ProductUploading extends ProductStates {}

// error
class ProductError extends ProductStates {
  final String message;
  ProductError(this.message);
}

// loaded
class ProductLoaded extends ProductStates {
  final List<Product> product;
  ProductLoaded(this.product);
}