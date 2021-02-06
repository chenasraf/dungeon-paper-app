part of 'db.dart';

class FirebaseHelpers {
  const FirebaseHelpers();

  Future<DocumentReference> create(
      DocumentReference ref, Map<String, dynamic> data) async {
    logger.d('Creating: ${ref.path}\n$data');
    await ref.set({...data, 'createdAt': DateTime.now()});
    return ref;
  }

  Future<DocumentReference> update(
    DocumentReference ref,
    Map<String, dynamic> data, {
    Iterable<String> keys,
  }) async {
    logger.d('FirebaseHelper: update');
    data = pick(data, keys);
    logger.d('Updating: ${ref.path}\n$data');
    await ref.update({...data, 'updatedAt': DateTime.now()});
    return ref;
  }

  Future<DocumentReference> move(
    DocumentReference ref,
    String newId, {
    Map<String, dynamic> update,
    bool useSameParent = true,
  }) async {
    logger.d(
      'Moving: ${ref.path}\n'
      'to: $newId, '
      'update: $update, '
      'useSameParent: $useSameParent',
    );
    final json = {
      ...(await ref.get()).data(),
      ...(update ?? {}),
    };
    final _ref = useSameParent ? ref.parent.doc(newId) : firestore.doc(newId);
    logger.d('Creating new document: ${_ref.path}');
    await create(_ref, json);
    logger.d('Success. Deleting ${ref.path}');
    await ref.delete();
    return _ref;
  }

  Future<void> delete(DocumentReference ref) async {
    logger.d('Deleting $this');
    return ref.delete();
  }

  Future<Iterable<T>> getRefs<T>(
          Iterable<DocumentReference> list, T Function(dynamic) map) =>
      Future.wait(
        list.map((r) => r.get()),
      ).then((chars) => chars.map(map));
}

mixin FirebaseMixin {
  static const helpers = FirebaseHelpers();

  DocumentReference get ref;
  Map<String, dynamic> toJson();

  DateTime get createdAt;
  DateTime get updatedAt;

  String get documentID => ref.id;

  Future<DocumentReference> create() => helpers.create(ref, toJson());

  Future<DocumentReference> update({Iterable<String> keys}) {
    logger.d('FirebaseMixin.update');
    return helpers.update(ref, toJson(), keys: keys);
  }

  Future<DocumentReference> move(
    String newId, {
    Map<String, dynamic> update,
    bool useSameParent = true,
  }) =>
      helpers.move(
        ref,
        newId,
        update: update,
        useSameParent: useSameParent,
      );

  Future<void> delete() => helpers.delete(ref);
}

mixin KeyMixin {
  String get key;
}
