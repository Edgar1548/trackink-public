enum ReadingType { manga, manhwa, manhua, tvSeries, movie, book, comic }

enum ReadingStatus {
  inProgress,
  completed,
  hiatus,
  noTranslation,
  dropped,
  planned,
}

class Reading {
  const Reading({
    required this.id,
    required this.title,
    required this.author,
    required this.type,
    required this.status,
    required this.progress,
    required this.tags,
    required this.description,
    required this.alternativeTitles,
    required this.createdAt,
    required this.updatedAt,
    this.score,
  });

  final String id;
  final String title;
  final String author;
  final ReadingType type;
  final ReadingStatus status;
  final int progress;
  final double? score;
  final List<String> tags;
  final String description;
  final List<String> alternativeTitles;
  final DateTime createdAt;
  final DateTime updatedAt;
}
