import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/src/features/readings/domain/entities/reading.dart';

void main() {
  test('represents a reading without Flutter dependencies', () {
    final timestamp = DateTime.utc(2026, 1, 1);
    final reading = Reading(
      id: 'reading-1',
      title: 'Example',
      author: 'Author',
      type: ReadingType.manga,
      status: ReadingStatus.inProgress,
      progress: 12,
      score: 4.5,
      tags: const ['Drama'],
      description: 'Description',
      alternativeTitles: const ['Alternative'],
      createdAt: timestamp,
      updatedAt: timestamp,
    );

    expect(reading.type, ReadingType.manga);
    expect(reading.status, ReadingStatus.inProgress);
    expect(reading.progress, 12);
    expect(reading.score, 4.5);
  });

  test('includes all supported reading types and statuses', () {
    expect(ReadingType.values, hasLength(7));
    expect(ReadingStatus.values, hasLength(6));
  });
}
