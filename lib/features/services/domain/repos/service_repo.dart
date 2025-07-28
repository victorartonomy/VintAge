import '../../../posts/domain/entities/comment.dart';
import '../entities/service.dart';

abstract class ServiceRepo {
  Future<List<Service>> fetchAllServices();
  Future<void> createService(Service service);
  Future<void> deleteService(String serviceId);
  Future<List<Service>> fetchServicesByUserId(String userId);
  Future<void> toggleLikeService(String serviceId, String userId);
  Future<void> addComment(String serviceId, Comment comment);
  Future<void> deleteComment(String serviceId, String commentId);
}