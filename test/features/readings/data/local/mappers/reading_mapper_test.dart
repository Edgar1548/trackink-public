import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/src/features/readings/data/local/database/app_database.dart';
import 'package:trackink/src/features/readings/data/local/mappers/reading_mapper.dart';
import 'package:trackink/src/features/readings/domain/entities/reading.dart';

void main() {
  final timestamp = DateTime.utc(2026, 1, 1);

  test('maps a database row and its tags to the domain', () {
    final row = ReadingRow(
      id: 'reading-1',
      title: 'Title',
      author: 'Author',
      type: 'manga',
      status: 'inProgress',
      progress: 10,
      score: 4.5,
      description: 'Description',
      alternativeTitles: '["Alternative"]',
      createdAt: timestamp,
      updatedAt: timestamp,
    );

    final reading = mapReadingRowToDomain(row, const [TagRow(id: 1, name: 'Drama')]);

    expect(reading.type, ReadingType.manga);
    expect(reading.status, ReadingStatus.inProgress);
    expect(reading.tags, ['Drama']);
    expect(reading.alternativeTitles, ['Alternative']);
  });

  test('maps the domain to a database companion', () {
    final reading = Reading(
      id: 'reading-1',
      title: 'Title',
      author: 'Author',
      type: ReadingType.movie,
      status: ReadingStatus.completed,
      progress: 1,
      score: 5,
      tags: const ['Drama'],
      description: 'Description',
      alternativeTitles: const ['Alternative'],
      createdAt: timestamp,
      updatedAt: timestamp,
    );

    final companion = mapReadingToCompanion(reading);

    expect(companion.type.value, 'movie');
    expect(companion.status.value, 'completed');
    expect(companion.alternativeTitles.value, '["Alternative"]');
  });

  test('rejects an unknown stored enum value', () {
    final row = ReadingRow(
      id: 'reading-1',
      title: 'Title',
      author: 'Author',
      type: 'unknown',
      status: 'inProgress',
      progress: 0,
      score: null,
      description: '',
      alternativeTitles: '[]',
      createdAt: timestamp,
      updatedAt: timestamp,
    );

    expect(() => mapReadingRowToDomain(row, const []), throwsFormatException);
  });
}
