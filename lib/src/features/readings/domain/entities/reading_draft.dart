import 'reading.dart';

class ReadingDraft {
  const ReadingDraft({
    required this.title,
    required this.author,
    required this.type,
    required this.status,
    required this.progress,
    required this.tags,
    required this.description,
    required this.alternativeTitles,
    this.score,
  });

  final String title;
  final String author;
  final ReadingType type;
  final ReadingStatus status;
  final int progress;
  final double? score;
  final List<String> tags;
  final String description;
  final List<String> alternativeTitles;
}
