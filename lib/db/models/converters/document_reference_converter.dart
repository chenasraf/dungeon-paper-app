import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dungeon_paper/db/db.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class DocumentReferenceConverter
    implements JsonConverter<DocumentReference, dynamic> {
  const DocumentReferenceConverter();

  @override
  DocumentReference fromJson(dynamic json) {
    if (json == null) {
      return null;
    }

    if (json is DocumentReference) {
      return json;
    }

    if (json['runtimeType'] != null) {
      return firestore.doc(json);
    }

    if (json['documentID']) {
      return firestore.doc(json['documentID']);
    } else {
      throw Exception(
          'Could not determine the constructor for mapping from JSON');
    }
  }

  @override
  dynamic toJson(DocumentReference data) => data;
}
