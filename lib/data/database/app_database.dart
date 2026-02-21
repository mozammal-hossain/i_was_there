import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

/// Place table (PRD R1–R4). Weekly presence is derived from Presence table.
class Places extends Table {
  TextColumn get placeId => text()();
  TextColumn get name => text()();
  TextColumn get address => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  IntColumn get syncStatusIndex => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {placeId};
}

/// Presence: (placeId, date) -> present or not (PRD R6, R7).
class Presences extends Table {
  TextColumn get placeId => text()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isPresent => boolean()();
  IntColumn get source => integer()(); // 0 = auto, 1 = manual
  DateTimeColumn get firstDetectedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {placeId, date};
}

/// Sync record: (placeId, date) synced to Google Calendar (PRD R15 – no duplicate sync).
class SyncRecords extends Table {
  TextColumn get placeId => text()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get syncedAt => dateTime()();
  TextColumn get eventId => text()();

  @override
  Set<Column> get primaryKey => {placeId, date};
}

/// Key-value for app settings (e.g. calendar sync on/off).
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [Places, Presences, SyncRecords, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbDir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbDir.path, 'i_was_there.db'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
