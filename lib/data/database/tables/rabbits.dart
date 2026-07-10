import 'package:drift/drift.dart';

@DataClassName('RabbitRow')
class Rabbits extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get sex => text()();
  TextColumn get birthDate => text().nullable()();
  TextColumn get adoptedDate => text().nullable()();
  TextColumn get breed => text()();
  TextColumn get furColor => text()();
  TextColumn get avatarPath => text().nullable()();
  TextColumn get source => text().nullable()();
  TextColumn get neuteredStatus => text().nullable()();
  TextColumn get neuteredDate => text().nullable()();
  TextColumn get chipNumber => text().nullable()();
  IntColumn get initialWeightGrams => integer().nullable()();
  TextColumn get personalityTagsJson => text().nullable()();
  TextColumn get favoriteFoods => text().nullable()();
  TextColumn get favoriteToys => text().nullable()();
  TextColumn get passedAwayDate => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
