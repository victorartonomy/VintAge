import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vintage/features/posts/domain/entities/comment.dart';
import '../domain/entities/service.dart';
import '../domain/repos/service_repo.dart';

class FirebaseServiceRepo implements ServiceRepo {

  // firestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // store all services in a collection called services
  final CollectionReference servicesCollection = FirebaseFirestore.instance.collection('services');

  @override
  Future<void> addComment(String serviceId, Comment comment) {
    // TODO: implement addComment
    throw UnimplementedError();
  }

  @override
  Future<void> createService(Service service) async {
    try {
      await servicesCollection.doc(service.id).set(service.toJson());
    } catch (e) {
      throw Exception("Failed to create service: $e");
    }
  }

  @override
  Future<void> deleteComment(String serviceId, String commentId) {
    // TODO: implement deleteComment
    throw UnimplementedError();
  }

  @override
  Future<void> deleteService(String serviceId) {
    // TODO: implement deleteService
    throw UnimplementedError();
  }

  @override
  Future<List<Service>> fetchAllServices() async {
    try {
      // get all services with the most recent services on top
      final servicesSnapshot = await servicesCollection.orderBy('timestamp', descending: true).get();

      // convert each firestore document from JSON to lists of services
      final List<Service> allServices = servicesSnapshot.docs
          .map((doc) => Service.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return allServices;
    } catch (e) {
      throw Exception("Failed to fetch services: $e");
    }
  }

  @override
  Future<List<Service>> fetchServicesByUserId(String userId) {
    // TODO: implement fetchServicesByUserId
    throw UnimplementedError();
  }

  @override
  Future<void> toggleLikeService(String serviceId, String userId) {
    // TODO: implement toggleLikeService
    throw UnimplementedError();
  }


  // methods to implement


}