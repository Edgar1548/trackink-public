import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../domain/entities/reading.dart';
import '../database/app_database.dart';

Reading mapReadingRowToDomain(ReadingRow row, Iterable<TagRow> tagRows) {
  return Reading(
    id: row.id,
    title: row.title,
    author: row.author,
    type: _readingTypeFromStorage(row.type),
    status: _readingStatusFromStorage(row.status),
    progress: row.progress,
    score: row.score,
    tags: tagRows.map((tag) => tag.name).toList(growable: false),
    description: row.description,
    alternativeTitles: _decodeAlternativeTitles(row.alternativeTitles),
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}

ReadingsCompanion mapReadingToCompanion(Reading reading) {
  return ReadingsCompanion.insert(
    id: reading.id,
    title: reading.title,
    author: Value(reading.author),
    type: _readingTypeToStorage(reading.type),
    status: _readingStatusToStorage(reading.status),
    progress: Value(reading.progress),
    score: Value(reading.score),
    description: Value(reading.description),
    alternativeTitles: Value(jsonEncode(reading.alternativeTitles)),
    createdAt: reading.createdAt,
    updatedAt: reading.updatedAt,
  );
}

List<String> _decodeAlternativeTitles(String encoded) {
  final Object? decoded;
  try {
    decoded = jsonDecode(encoded);
  } on FormatException catch (error) {
    throw FormatException('Invalid alternative titles JSON', encoded, error.offset);
  }

  if (decoded is! List || decoded.any((value) => value is! String)) {
    throw FormatException('Alternative titles must be a list of strings', encoded);
  }

  return decoded.cast<String>().toList(growable: false);
}

String _readingTypeToStorage(ReadingType type) => switch (type) {
  ReadingType.manga => 'manga',
  ReadingType.manhwa => 'manhwa',
  ReadingType.manhua => 'manhua',
  ReadingType.tvSeries => 'tvSeries',
  ReadingType.movie => 'movie',
  ReadingType.book => 'book',
  ReadingType.comic => 'comic',
};

ReadingType _readingTypeFromStorage(String value) => switch (value) {
  'manga' => ReadingType.manga,
  'manhwa' => ReadingType.manhwa,
  'manhua' => ReadingType.manhua,
  'tvSeries' => ReadingType.tvSeries,
  'movie' => ReadingType.movie,
  'book' => ReadingType.book,
  'comic' => ReadingType.comic,
  _ => throw FormatException('Unknown reading type', value),
};

String _readingStatusToStorage(ReadingStatus status) => switch (status) {
  ReadingStatus.inProgress => 'inProgress',
  ReadingStatus.completed => 'completed',
  ReadingStatus.hiatus => 'hiatus',
  ReadingStatus.noTranslation => 'noTranslation',
  ReadingStatus.dropped => 'dropped',
  ReadingStatus.planned => 'planned',
};

ReadingStatus _readingStatusFromStorage(String value) => switch (value) {
  'inProgress' => ReadingStatus.inProgress,
  'completed' => ReadingStatus.completed,
  'hiatus' => ReadingStatus.hiatus,
  'noTranslation' => ReadingStatus.noTranslation,
  'dropped' => ReadingStatus.dropped,
  'planned' => ReadingStatus.planned,
  _ => throw FormatException('Unknown reading status', value),
};
