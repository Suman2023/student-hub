class FeedsTimeline {
  FeedsTimeline({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.aspectratio,
    required this.text,
    required this.imageurl,
    required this.totalLike,
    required this.likedByme,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String text, imageurl, username, firstName,lastName;
  int totalLike, likedByme;
  DateTime createdAt, updatedAt;
  double aspectratio;
}
