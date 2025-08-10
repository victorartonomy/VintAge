import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/shop/domain/entities/product.dart';
import 'package:vintage/features/shop/domain/repos/product_repo.dart';
import 'package:vintage/features/shop/presentation/cubits/product_states.dart';
import 'package:vintage/features/storage/domain/storage_repo.dart';

class ProductCubit extends Cubit<ProductStates> {
  final ProductRepo productRepo;
  final StorageRepo storageRepo;
  ProductCubit({required this.productRepo, required this.storageRepo})
    : super(ProductInitial());

  // create a new service
  Future<void> createProduct(
    Product product, {
    List<String>? imagePaths,
    List<Uint8List>? imageBytesList,
  }) async {
    List<String>? imageUrls;
    try {
      // mobile: upload multiple image paths
      if (imagePaths != null && imagePaths.isNotEmpty) {
        emit(ProductUploading());
        // Ensure you pass list of both image paths and file names
        final fileNames =
        imagePaths
            .map((p) => '${product.id}_${p.split('/').last}')
            .toList();
        imageUrls = await storageRepo.uploadProductImagesMobile(
          imagePaths,
          fileNames,
        );
      }
      // web: upload multiple image files (bytes)
      else if (imageBytesList != null && imageBytesList.isNotEmpty) {
        emit(ProductUploading());
        // Assign unique file names as needed
        final fileNames = List.generate(
          imageBytesList.length,
              (i) => "${product.id}_$i.jpg",
        );
        imageUrls = await storageRepo.uploadProductImagesWeb(
          imageBytesList,
          fileNames,
        );
      }
      // else: no images
      else {
        imageUrls = [];
      }

      // Update the product with imageUrls
      final newProduct = product.copyWith(imagesUrl: imageUrls);

      // Await backend product creation
      await productRepo.createProduct(newProduct);

      // Re-fetch all products
      await fetchAllProducts();
    } catch (e) {
      emit(ProductError("Failed to create product: $e"));

    }
  }

  // fetch all products
  Future<void> fetchAllProducts() async {
    try {
      emit(ProductLoading());
      final products = await productRepo.fetchAllProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError("Failed to fetch products: $e"));
    }
  }

  // toggle likes
  Future<void> toggleLike(String productId, String userId) async {
    try {
      await productRepo.toggleLikeProduct(productId, userId);
    } catch (e) {
      emit(ProductError("Failed to toggle like: $e"));
    }
  }

  // delete product
  Future<void> deleteProduct(String productId) async {
    try {
      await productRepo.deleteProduct(productId);
    } catch (e) {
      emit(ProductError("Failed to delete product: $e"));
    }
  }

  // rate product
  Future<void> rateProduct(String productId, String userId, int rating) async {
    try {
      await productRepo.rateProduct(productId, userId, rating);
      // Re-fetch all products to update the UI
      await fetchAllProducts();
    } catch (e) {
      emit(ProductError("Failed to rate product: $e"));
    }
  }

  // get user rating for a product
  Future<int?> getUserRating(String productId, String userId) async {
    try {
      return await productRepo.getUserRating(productId, userId);
    } catch (e) {
      emit(ProductError("Failed to get user rating: $e"));
      return null;
    }
  }
}
