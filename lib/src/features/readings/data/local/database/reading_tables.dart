import 'package:drift/drift.dart';

@DataClassName('ReadingRow')
class Readings extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get author => text().withDefault(const Constant(''))();
  TextColumn get type => text()();
  TextColumn get status => text()();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  RealColumn get score => real().nullable()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get alternativeTitles =>
      text().withDefault(const Constant('[]'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('TagRow')
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
}

@DataClassName('ReadingTagRow')
class ReadingTags extends Table {
  TextColumn get readingId => text().references(
    Readings,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get tagId => integer().references(
    Tags,
    #id,
    onDelete: KeyAction.cascade,
  )();

  @override
  Set<Column<Object>> get primaryKey => {readingId, tagId};
}
