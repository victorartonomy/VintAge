class Service {
  final String id;
  final String userId;
  final String userName;
  final String title;
  final List<String> imagesUrl;
  final String description;
  final List<String> lstServices;
  final String contactNumber;
  final String contactEmail;
  final String timing;
  final String address;
  final String website;
  final DateTime timestamp;
  final int ratings;
  final Map<String, int> userRatings; // userId -> rating (1-5)
  final List<String> likes;
  final List<String> comments;

  Service({
    required this.id,
    required this.userId,
    required this.userName,
    required this.title,
    required this.imagesUrl,
    required this.description,
    required this.lstServices,
    required this.contactNumber,
    required this.contactEmail,
    required this.timing,
    required this.address,
    required this.website,
    required this.timestamp,
    required this.ratings,
    required this.userRatings,
    required this.likes,
    required this.comments,
  });

  // Get average rating
  double get averageRating {
    if (userRatings.isEmpty) return 0.0;
    int totalRating = userRatings.values.fold(0, (sum, rating) => sum + rating);
    return totalRating / userRatings.length;
  }

  // Get user's rating for this service
  int? getUserRating(String userId) {
    return userRatings[userId];
  }

  // create modified copies of service
  Service copyWith({
    List<String>? imagesUrl,
    Map<String, int>? userRatings,
    int? ratings,
  }) {
    return Service(
      id: id,
      userId: userId,
      userName: userName,
      title: title,
      imagesUrl: imagesUrl ?? this.imagesUrl,
      description: description,
      lstServices: lstServices,
      contactNumber: contactNumber,
      contactEmail: contactEmail,
      timing: timing,
      address: address,
      website: website,
      timestamp: timestamp,
      ratings: ratings ?? this.ratings,
      userRatings: userRatings ?? this.userRatings,
      likes: likes,
      comments: comments,
    );
  }

  // convert service -> json
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "userName": userName,
      "title": title,
      "imagesUrl": imagesUrl,
      "description": description,
      "lstServices": lstServices,
      "contactNumber": contactNumber,
      "contactEmail": contactEmail,
      "timing": timing,
      "address": address,
      "website": website,
      "timestamp": timestamp,
      "ratings": ratings,
      "userRatings": userRatings,
      "likes": likes,
      "comments": comments,
    };
  }

  // convert json -> service
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json["id"],
      userId: json["userId"],
      userName: json["userName"],
      title: json["title"],
      imagesUrl: List<String>.from(json['imagesUrl'] ?? []),
      description: json["description"],
      lstServices: List<String>.from(json['lstServices'] ?? []),
      contactNumber: json["contactNumber"],
      contactEmail: json["contactEmail"],
      timing: json["timing"],
      address: json["address"],
      website: json["website"],
      timestamp: json["timestamp"].toDate(),
      ratings: json["ratings"] ?? 0,
      userRatings: Map<String, int>.from(json['userRatings'] ?? {}),
      likes: List<String>.from(json['likes'] ?? []),
      comments: List<String>.from(json['comments'] ?? []),
    );
  }
}
