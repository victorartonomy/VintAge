import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:vintage/features/storage/domain/storage_repo.dart';

class FirebaseStorageRepo implements StorageRepo {
  final FirebaseStorage storage = FirebaseStorage.instance;

  /*

  Upload Profile Images

   */

  // mobile platform
  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "profile_images");
  }

  // web platform
  @override
  Future<String?> uploadProfileImageWeb(Uint8List file, String fileName) {
    return _uploadBytes(file, fileName, "profile_images");
  }

  /*

  Upload Post Images

   */

  @override
  Future<String?> uploadPostImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "post_images");
  }

  @override
  Future<String?> uploadPostImageWeb(Uint8List file, String fileName) {
    return _uploadBytes(file, fileName, "post_images");

  }


  // ---- SERVICE IMAGES UPLOAD (MULTIPLE FILES) ----
  // Mobile (multiple image upload)
  @override
  Future<List<String>?> uploadServiceImagesMobile(List<String> paths, List<String> fileNames) async {
    try {
      List<String> urls = [];
      for (int i = 0; i < paths.length; i++) {
        String? url = await _uploadFile(paths[i], fileNames[i], "service_images");
        if (url != null) {
          urls.add(url);
        }
      }
      return urls;
    } catch (e) {
      // Log error somewhere or rethrow for upper layers
      return null;
    }
  }

  // Web (multiple image upload)
  @override
  Future<List<String>?> uploadServiceImagesWeb(List<Uint8List> files, List<String> fileNames) async {
    try {
      List<String> urls = [];
      for (int i = 0; i < files.length; i++) {
        String? url = await _uploadBytes(files[i], fileNames[i], "service_images");
        if (url != null) {
          urls.add(url);
        }
      }
      return urls;
    } catch (e) {
      // Log error somewhere or rethrow for upper layers
      return null;
    }
  }


  /*

  Helper Methods - to upload files to storage

   */

  // mobile platform uploading files
  Future<String?> _uploadFile(String path, String fileName, String folder) async {
    try {

      // get file
      final file = File(path);

      // find place to store
      final storageRef = storage.ref().child('$folder/$fileName');

      // upload
      final uploadTask = await storageRef.putFile(file);

      // get image download url
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      // return url
      return downloadUrl;

    }

    catch (e) {
      return null;
    }
  }

  // web platform uploading bytes
  Future<String?> _uploadBytes(Uint8List fileBytes, String fileName, String folder) async {
    try {

      // find place to store
      final storageRef = storage.ref().child('$folder/$fileName');

      // upload
      final uploadTask = await storageRef.putData(fileBytes);

      // get image download url
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      // return url
      return downloadUrl;

    }
    catch (e) {
      return null;
    }
  }
}