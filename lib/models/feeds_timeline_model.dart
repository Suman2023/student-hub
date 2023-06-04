class FeedsTimeline {
  FeedsTimeline({
    required this.id,
    required this.text,
    required this.imageurl,
    required this.totalLike,
    required this.likedByme,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String text, imageurl;
  int totalLike, likedByme;
  DateTime createdAt, updatedAt;
}
