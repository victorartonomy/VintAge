import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/services/domain/entities/service.dart';
import 'package:vintage/features/services/presentation/cubits/service_states.dart';

import '../../../storage/domain/storage_repo.dart';
import '../../domain/repos/service_repo.dart';

class ServiceCubit extends Cubit<ServiceStates> {
  final ServiceRepo serviceRepo;
  final StorageRepo storageRepo;
  ServiceCubit({required this.serviceRepo, required this.storageRepo})
    : super(ServicesInitial());

  // create a new service
  Future<void> createService(
    Service service, {
    List<String>? imagePaths,
    List<Uint8List>? imageBytesList,
  }) async {
    List<String>? imageUrls;
    try {
      // Mobile: upload multiple image paths
      if (imagePaths != null && imagePaths.isNotEmpty) {
        emit(ServicesUploading());
        // Ensure you pass list of both image paths and file names
        final fileNames =
            imagePaths
                .map((p) => '${service.id}_${p.split('/').last}')
                .toList();
        imageUrls = await storageRepo.uploadServiceImagesMobile(
          imagePaths,
          fileNames,
        );
      }
      // Web: upload multiple image files (bytes)
      else if (imageBytesList != null && imageBytesList.isNotEmpty) {
        emit(ServicesUploading());
        // Assign unique file names as needed
        final fileNames = List.generate(
          imageBytesList.length,
          (i) => "${service.id}_$i.jpg",
        );
        imageUrls = await storageRepo.uploadServiceImagesWeb(
          imageBytesList,
          fileNames,
        );
      }
      // else: no images
      else {
        imageUrls = [];
      }

      // Update the service with imageUrls
      final newService = service.copyWith(imagesUrl: imageUrls);

      // Await backend service creation
      await serviceRepo.createService(newService);

      // Re-fetch all services
      await fetchAllServices();
    } catch (e) {
      emit(ServicesError("Failed to create service: $e"));
    }
  }

  // fetch all services
  Future<void> fetchAllServices() async {
    try {
      emit(ServicesLoading());
      final services = await serviceRepo.fetchAllServices();
      emit(ServicesLoaded(services));
    } catch (e) {
      emit(ServicesError("Failed to fetch services: $e"));
    }
  }

  // toggle likes
  Future<void> toggleLike(String serviceId, String userId) async {
    try {
      await serviceRepo.toggleLikeService(serviceId, userId);
    } catch (e) {
      emit(ServicesError("Failed to toggle like: $e"));
    }
  }

  // delete service
  Future<void> deleteService(String serviceId) async {
    try {
      await serviceRepo.deleteService(serviceId);
    } catch (e) {
      emit(ServicesError("Failed to delete service: $e"));
    }
  }

  // rate service
  Future<void> rateService(String serviceId, String userId, int rating) async {
    try {
      await serviceRepo.rateService(serviceId, userId, rating);
      // Re-fetch all services to update the UI
      await fetchAllServices();
    } catch (e) {
      emit(ServicesError("Failed to rate service: $e"));
    }
  }

  // get user rating for a service
  Future<int?> getUserRating(String serviceId, String userId) async {
    try {
      return await serviceRepo.getUserRating(serviceId, userId);
    } catch (e) {
      emit(ServicesError("Failed to get user rating: $e"));
      return null;
    }
  }
}
