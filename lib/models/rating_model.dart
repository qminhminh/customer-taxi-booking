class Rating {
  final String userId;
  final int rating;

  Rating({
    required this.userId,
    required this.rating,
  });

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      userId: map['userId'] ?? '',
      rating: map['rating'] ?? 0,
    );
  }
}
