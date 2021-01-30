import 'package:flutter/foundation.dart';

class MoveTemplate {
  final String shortLabel;
  final String longLabel;
  final String text;
  final String help;

  const MoveTemplate({
    @required this.shortLabel,
    @required this.longLabel,
    @required this.text,
    @required this.help,
  });
}
