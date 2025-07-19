import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vintage/features/posts/domain/entities/comment.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String imageUrl;
  final DateTime timestamp;
  final List<String> likes; // Store uids of those who liked the post
  final List<Comment> comments;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.imageUrl,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });

  Post copyWith({String? imageUrl}) {
    return Post(
      id: id,
      userId: userId,
      userName: userName,
      text: text,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp,
      likes: likes,
      comments: comments,
    );
  }

  // convert post -> JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "userName": userName,
      "text": text,
      "imageUrl": imageUrl,
      "timestamp": timestamp,
      "likes": likes,
      "comments": comments.map((comment) => comment.toJson()).toList(),
    };
  }

  // convert JSON -> post
  factory Post.fromJson(Map<String, dynamic> json) {
    // prepare comments
    // final List<Comment> comments =
    //     (json['comments'] as List<dynamic>?)
    //         ?.map((commentJson) => Comment.fromJson(commentJson))
    //         .toList() ??
    //     [];

    return Post(
      id: json["id"],
      userId: json["userId"],
      userName: json["userName"],
      text: json["text"],
      imageUrl: json["imageUrl"],
      timestamp: (json["timestamp"] as Timestamp).toDate(),
      likes: List<String>.from(json['likes'] ?? []),
      comments: List<Comment>.from(
        json['comments']?.map((comment) => Comment.fromJson(comment)) ?? [],
      ),
    );
  }
}
