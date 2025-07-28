class Service {
  final String id;
  final String userId;
  final String userName;
  final String title;
  final List<String> imagesUrl;
  final String description;
  final String contactNumber;
  final String contactEmail;
  final String timing;
  final String address;
  final DateTime timestamp;
  final int ratings;
  final List<String> likes;
  final List<String> comments;

  Service({
    required this.id,
    required this.userId,
    required this.userName,
    required this.title,
    required this.imagesUrl,
    required this.description,
    required this.contactNumber,
    required this.contactEmail,
    required this.timing,
    required this.address,
    required this.timestamp,
    required this.ratings,
    required this.likes,
    required this.comments,
  });

  // create modified copies of service
  Service copyWith({List<String>? imagesUrl}) {
    return Service(
      id: id,
      userId: userId,
      userName: userName,
      title: title,
      imagesUrl: imagesUrl ?? this.imagesUrl,
      description: description,
      contactNumber: contactNumber,
      contactEmail: contactEmail,
      timing: timing,
      address: address,
      timestamp: timestamp,
      ratings: ratings,
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
      "timing": timing,
      "address": address,
      "timestamp": timestamp,
      "ratings": ratings,
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
      contactNumber: json["contactNumber"],
      contactEmail: json["contactEmail"],
      timing: json["timing"],
      address: json["address"],
      timestamp: json["timestamp"].toDate(),
      ratings: json["ratings"],
      likes: List<String>.from(json['likes'] ?? []),
      comments: List<String>.from(json['comments'] ?? []),
    );
  }
}
