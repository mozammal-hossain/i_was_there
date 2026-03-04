import 'package:i_was_there/data/database/app_database.dart';
import 'package:i_was_there/data/sync/repositories/sync_repository_impl.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';

void main() async {
  final db = AppDatabase();
  final repo = SyncRepositoryImpl(db);

  print('Checking pending syncs...');
  try {
    final pending = await repo.getPendingSyncs();
    print('Pending items count: ${pending.length}');
    for (final item in pending) {
      print(' - ${item.placeName} on ${item.date}');
    }

    // Check all presences
    final allPresences = await db.select(db.presences).get();
    print('Total presences in DB: ${allPresences.length}');
    for (final p in allPresences) {
      print(' Presence: ${p.placeId}, ${p.date}, isPresent: ${p.isPresent}');
    }

    // Check all sync records
    final allSyncs = await db.select(db.syncRecords).get();
    print('Total sync records in DB: ${allSyncs.length}');
    for (final s in allSyncs) {
      print(' SyncRecord: ${s.placeId}, ${s.date}, eventId: ${s.eventId}');
    }

    // Check all places
    final allPlaces = await db.select(db.places).get();
    print('Total places in DB: ${allPlaces.length}');
    for (final p in allPlaces) {
      print(
        ' Place: ${p.placeId}, ${p.name}, syncStatusIndex: ${p.syncStatusIndex}',
      );
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    await db.close();
  }
}
