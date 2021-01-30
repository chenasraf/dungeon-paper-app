import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class DateTimeConverter implements JsonConverter<DateTime, dynamic> {
  const DateTimeConverter();

  @override
  DateTime fromJson(dynamic json) {
    if (json == null) {
      return null;
    }

    if (json is Timestamp) {
      return json.toDate();
    }

    return DateTime.parse(json);
  }

  @override
  dynamic toJson(DateTime data) =>
      data != null ? Timestamp.fromDate(data) : null;
}
