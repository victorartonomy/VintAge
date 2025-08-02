import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vintage/features/posts/domain/entities/comment.dart';
import '../domain/entities/service.dart';
import '../domain/repos/service_repo.dart';

class FirebaseServiceRepo implements ServiceRepo {
  // firestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // store all services in a collection called services
  final CollectionReference servicesCollection = FirebaseFirestore.instance
      .collection('services');

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
  Future<void> deleteService(String serviceId) async {
    try {
      await servicesCollection.doc(serviceId).delete();
    } catch (e) {
      throw Exception("Failed to delete service: $e");
    }
  }

  @override
  Future<List<Service>> fetchAllServices() async {
    try {
      // get all services with the most recent services on top
      final servicesSnapshot =
          await servicesCollection.orderBy('timestamp', descending: true).get();

      // convert each firestore document from JSON to lists of services
      final List<Service> allServices =
          servicesSnapshot.docs
              .map(
                (doc) => Service.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList();

      return allServices;
    } catch (e) {
      throw Exception("Failed to fetch services: $e");
    }
  }

  @override
  Future<List<Service>> fetchServicesByUserId(String userId) async {
    try {
      // fetch posts snapshot with this uid
      final servicesSnapshot =
          await servicesCollection.where('uid', isEqualTo: userId).get();

      // convert from JSON to lists of services
      final List<Service> userServices =
          servicesSnapshot.docs
              .map(
                (doc) => Service.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList();

      return userServices;
    } catch (e) {
      throw Exception("Failed to fetch services: $e");
    }
  }

  @override
  Future<void> toggleLikeService(String serviceId, String userId) async {
    try {
      // get the service document from firestore
      final serviceDoc = await servicesCollection.doc(serviceId).get();

      // check if doc exists
      if (serviceDoc.exists) {
        final service = Service.fromJson(
          serviceDoc.data() as Map<String, dynamic>,
        );

        // check if user has already liked the service
        if (service.likes.contains(userId)) {
          // remove user from likes
          service.likes.remove(userId);
        } else {
          // add user to likes
          service.likes.add(userId);
        }

        // update the service document in firestore
        await servicesCollection.doc(serviceId).update({
          'likes': service.likes,
        });
      } else {
        throw Exception("Service not found");
      }
    } catch (e) {
      throw Exception("Failed to toggle like: $e");
    }
  }

  @override
  Future<void> rateService(String serviceId, String userId, int rating) async {
    try {
      // Validate rating (1-5)
      if (rating < 1 || rating > 5) {
        throw Exception("Rating must be between 1 and 5");
      }

      // get the service document from firestore
      final serviceDoc = await servicesCollection.doc(serviceId).get();

      // check if doc exists
      if (serviceDoc.exists) {
        final service = Service.fromJson(
          serviceDoc.data() as Map<String, dynamic>,
        );

        // Create a new map with the updated rating
        Map<String, int> updatedUserRatings = Map.from(service.userRatings);
        updatedUserRatings[userId] = rating;

        // update the service document in firestore
        await servicesCollection.doc(serviceId).update({
          'userRatings': updatedUserRatings,
        });
      } else {
        throw Exception("Service not found");
      }
    } catch (e) {
      throw Exception("Failed to rate service: $e");
    }
  }

  @override
  Future<int?> getUserRating(String serviceId, String userId) async {
    try {
      // get the service document from firestore
      final serviceDoc = await servicesCollection.doc(serviceId).get();

      // check if doc exists
      if (serviceDoc.exists) {
        final service = Service.fromJson(
          serviceDoc.data() as Map<String, dynamic>,
        );
        return service.getUserRating(userId);
      } else {
        throw Exception("Service not found");
      }
    } catch (e) {
      throw Exception("Failed to get user rating: $e");
    }
  }
}
