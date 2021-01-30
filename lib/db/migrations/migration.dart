import 'package:cloud_firestore/cloud_firestore.dart';

class Migration {
  final String name;
  final Map<String, dynamic> Function(Map<String, dynamic> data) run;
  final bool Function(Map<String, dynamic> data) condition;

  Migration(this.name, this.run, [this.condition]);
}

abstract class MigrationRunner<T> {
  List<Migration> get migrations;

  T fromJson(Map<String, dynamic> data, DocumentReference reference);

  Future<T> run(DocumentSnapshot snapshot) async {
    final data = await _prepareData(snapshot);
    return fromJson(data, snapshot.reference);
  }

  Future<List<T>> runAll(Iterable<DocumentSnapshot> snapshots) =>
      Future.wait(snapshots.map(
        (snapshot) => run(snapshot),
      ));

  Future<Map<String, dynamic>> _prepareData(DocumentSnapshot snapshot) async {
    final data = snapshot.data();
    final updates = <String, dynamic>{};

    migrations.forEach((migration) {
      print(
          'Checking migration: ${migration.name} for document: ${snapshot.reference.path}');
      if (!migration.condition(data)) {
        return;
      }
      final result = migration.run(data);
      if (result == null || result.isEmpty) {
        return;
      }
      updates.addAll(result);
      print('Migrated: ${migration.name}, updated keys: ${result.keys}');
    });

    if (updates.isEmpty) {
      return data;
    }
    print('Done running all migrations. Saving ${updates.keys}...');
    await snapshot.reference.update(updates);

    print('Done saving data.');
    return {...data, ...updates};
  }
}
