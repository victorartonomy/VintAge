import 'dart:typed_data';

abstract class StorageRepo {
  // upload profile images on mobile platform
  Future<String?> uploadProfileImageMobile(String path, String fileName);

  // upload profile images on web platform
  Future<String?> uploadProfileImageWeb(Uint8List file, String fileName);

  // upload post images on mobile platform
  Future<String?> uploadPostImageMobile(String path, String fileName);

  // upload post images on web platform
  Future<String?> uploadPostImageWeb(Uint8List file, String fileName);

  // upload service images on mobile platform
  Future<List<String>?> uploadServiceImagesMobile(List<String> paths, List<String> fileNames);

  // upload service images on web platform
  Future<List<String>?> uploadServiceImagesWeb(List<Uint8List> files, List<String> fileNames);

  // upload service images on mobile platform
  Future<List<String>?> uploadProductImagesMobile(List<String> paths, List<String> fileNames);

  // upload service images on web platform
  Future<List<String>?> uploadProductImagesWeb(List<Uint8List> files, List<String> fileNames);
}