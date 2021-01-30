import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:flutter/painting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

final _alignmentMapping = {
  'topLeft': Alignment.topLeft,
  'topCenter': Alignment.topCenter,
  'topRight': Alignment.topRight,
  'centerLeft': Alignment.centerLeft,
  'center': Alignment.center,
  'centerRight': Alignment.centerRight,
  'bottomLeft': Alignment.bottomLeft,
  'bottomCenter': Alignment.bottomCenter,
  'bottomRight': Alignment.bottomRight,
};

class FlutterAlignmentConverter implements JsonConverter<Alignment, String> {
  const FlutterAlignmentConverter();

  @override
  Alignment fromJson(String alignment) {
    if (alignment == null) {
      return Alignment.topCenter;
    }
    return _alignmentMapping[alignment] ?? Alignment.topCenter;
  }

  @override
  String toJson(Alignment data) => enumName(data);
}
