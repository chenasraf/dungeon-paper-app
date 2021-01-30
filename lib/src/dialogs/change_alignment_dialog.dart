import 'package:dungeon_paper/db/helpers/character_utils.dart' as chr;
import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/src/dialogs/dialogs.dart';
import 'package:dungeon_paper/src/atoms/alignment_description_card.dart';
import 'package:dungeon_paper/src/utils/types.dart';
import 'package:flutter/material.dart';

class ChangeAlignmentDialog extends StatelessWidget {
  final DialogMode mode;
  final VoidCallbackDelegate<Character> onUpdate;
  final Character character;

  const ChangeAlignmentDialog({
    Key key,
    @required this.character,
    @required this.onUpdate,
    this.mode = DialogMode.edit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: chr.AlignmentName.values
              .map(
                (alignment) => AlignmentDescription(
                  playerClass: character.mainClass,
                  alignment: alignment,
                  onTap: changeAlignment(alignment),
                  selected: alignment == character.alignment,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Function() changeAlignment(chr.AlignmentName def) {
    return () async {
      final char = character.copyWith(alignment: def);
      onUpdate?.call(char);
    };
  }
}
