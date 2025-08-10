class Product {
  final String id;
  final String userId;
  final String userName;
  final String title;
  final List<String> imagesUrl;
  final String description;
  final String contactNumber;
  final String contactEmail;
  final String address;
  final DateTime timestamp;
  final String price;
  final int ratings;
  final Map<String, int> userRatings; // userId -> rating (1-5)
  final List<String> likes;
  final List<String> comments;

  Product({
    required this.id,
    required this.userId,
    required this.userName,
    required this.title,
    required this.imagesUrl,
    required this.description,
    required this.contactNumber,
    required this.contactEmail,
    required this.address,
    required this.timestamp,
    required this.price,
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
  Product copyWith({
    List<String>? imagesUrl,
    Map<String, int>? userRatings,
    int? ratings,
  }) {
    return Product(
      id: id,
      userId: userId,
      userName: userName,
      title: title,
      imagesUrl: imagesUrl ?? this.imagesUrl,
      description: description,
      contactNumber: contactNumber,
      contactEmail: contactEmail,
      address: address,
      timestamp: timestamp,
      price: price,
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
      "contactNumber": contactNumber,
      "contactEmail": contactEmail,
      "address": address,
      "timestamp": timestamp,
      "price": price,
      "ratings": ratings,
      "userRatings": userRatings,
      "likes": likes,
      "comments": comments,
    };
  }

  // convert json -> service
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      userId: json["userId"],
      userName: json["userName"],
      title: json["title"],
      imagesUrl: List<String>.from(json['imagesUrl'] ?? []),
      description: json["description"],
      contactNumber: json["contactNumber"],
      contactEmail: json["contactEmail"],
      address: json["address"],
      price: json["price"],
      timestamp: json["timestamp"].toDate(),
      ratings: json["ratings"] ?? 0,
      userRatings: Map<String, int>.from(json['userRatings'] ?? {}),
      likes: List<String>.from(json['likes'] ?? []),
      comments: List<String>.from(json['comments'] ?? []),
    );
  }
}
