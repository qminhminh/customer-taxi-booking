class Rating {
  final String userId;
  final int rating;
  final String tripID;

  Rating({
    required this.userId,
    required this.rating,
    required this.tripID,
  });

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      userId: map['userId'] ?? '',
      rating: map['rating'] ?? 0,
      tripID: map['tripID'] ?? '',
    );
  }
}
