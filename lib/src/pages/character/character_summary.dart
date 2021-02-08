import 'package:dungeon_paper/db/helpers/character_utils.dart' as chr;
import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/src/atoms/card_list_item.dart';
import 'package:dungeon_paper/src/molecules/character_headline.dart';
import 'package:dungeon_paper/src/molecules/character_photo.dart';
import 'package:dungeon_paper/src/molecules/stats_summary.dart';
import 'package:dungeon_paper/src/pages/character/looks_view.dart';
import 'package:dungeon_paper/src/pages/character/select_race_move_view.dart';
import 'package:dungeon_paper/src/utils/types.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:dungeon_world_data/alignment.dart' as dwa_alignment;
import 'package:get/get.dart';

class CharacterSummary extends StatelessWidget {
  final Character character;
  final VoidCallbackDelegate<Character> onSave;

  CharacterSummary({
    Key key,
    @required this.character,
    @required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var child = Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        // color: Colors.red,
        child: Column(
          children: <Widget>[
            if (character.photoURL != null)
              CharacterPhoto(character: character),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: CharacterHeadline(
                character: character,
                editable: false,
              ),
            ),
            StatsSummary(character: character),
            singleChildRow(
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0, top: 8),
                child: ClassSummary(character: character),
              ),
            ),
            singleChildRow(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: AlignmentSummary(character: character),
              ),
            ),
            singleChildRow(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: RaceSummary(character: character),
              ),
            ),
            singleChildRow(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: LooksSummary(character: character),
              ),
            ),
          ],
        ),
      ),
    );
    return child;
  }

  Widget singleChildRow(Widget child) {
    return Row(children: [Expanded(child: child)]);
  }
}

class AlignmentSummary extends StatelessWidget {
  final Character character;

  AlignmentSummary({
    Key key,
    @required this.character,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alignment = character.playerClass.alignments.containsKey(alignmentKey)
        ? character.playerClass.alignments[alignmentKey]
        : dwa_alignment.Alignment(
            name: capitalize(alignmentKey),
            description: null,
          );
    return CardListItem(
      elevation: 0.0,
      margin: EdgeInsets.all(0),
      color: Get.theme.canvasColor.withOpacity(0.5),
      leading: Icon(icon, size: 40),
      title: Text(alignment.name ?? 'No Alignment'),
      subtitle:
          alignment.description != null ? Text(alignment.description) : null,
    );
  }

  String get alignmentKey => enumName(character.alignment);
  IconData get icon => chr.ALIGNMENT_ICON_MAP[character.alignment];
}

class RaceSummary extends StatelessWidget {
  final Character character;

  RaceSummary({
    Key key,
    @required this.character,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaceDescription(
      race: character.race,
      playerClass: character.playerClass,
      color: Get.theme.canvasColor.withOpacity(0.5),
      elevation: 0,
      margin: EdgeInsets.all(0),
    );
  }

  String get alignmentKey => enumName(character.alignment);
  IconData get icon => chr.ALIGNMENT_ICON_MAP[character.alignment];
}

class ClassSummary extends StatelessWidget {
  final Character character;

  ClassSummary({
    Key key,
    @required this.character,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardListItem(
      title: Text(character.playerClass.name),
      subtitle: character.playerClass.description != null &&
              character.playerClass.description.trim().isNotEmpty
          ? Text(
              character.playerClass.description,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      leading: Icon(Icons.person, size: 40.0),
      color: Get.theme.canvasColor.withOpacity(0.5),
      elevation: 0,
      margin: EdgeInsets.all(0),
    );
  }

  String get alignmentKey => enumName(character.alignment);
  IconData get icon => chr.ALIGNMENT_ICON_MAP[character.alignment];
}

class LooksSummary extends StatelessWidget {
  final Character character;

  LooksSummary({
    Key key,
    @required this.character,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LooksDescription(
      playerClass: character.playerClass,
      looks: character.looks,
      color: Get.theme.canvasColor.withOpacity(0.5),
      elevation: 0,
      margin: EdgeInsets.all(0),
    );
  }

  String get alignmentKey => enumName(character.alignment);
  IconData get icon => chr.ALIGNMENT_ICON_MAP[character.alignment];
}
