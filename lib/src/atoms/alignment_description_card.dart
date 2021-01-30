import 'package:dungeon_paper/db/helpers/character_utils.dart' as chr;
import 'package:dungeon_paper/src/atoms/card_list_item.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:dungeon_world_data/player_class.dart';
import 'package:dungeon_world_data/alignment.dart' as dw;
import 'package:get/get.dart';

class AlignmentDescription extends StatelessWidget {
  final PlayerClass playerClass;
  final chr.AlignmentName alignment;
  final VoidCallback onTap;
  final int level;
  final bool selected;

  const AlignmentDescription({
    Key key,
    @required this.playerClass,
    @required this.alignment,
    this.level,
    this.onTap,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alignmentKey = enumName(alignment);
    final alignmentInfo = (playerClass?.alignments?.containsKey(alignmentKey) ==
                true
            ? playerClass.alignments[alignmentKey]
            : null) ??
        dw.Alignment(key: alignmentKey, name: alignmentKey, description: '');
    final hasDescription = alignmentInfo.description.isNotEmpty;

    final texts = <Widget>[
      Text(
        capitalize(alignmentInfo.name),
        style: Get.theme.textTheme.headline6,
      ),
    ];
    if (hasDescription) {
      texts.add(Text(
        alignmentInfo.description,
        style: Get.theme.textTheme.bodyText2,
      ));
    }
    return CardListItem(
      leading: Icon(icon, size: 40.0),
      trailing: onTap != null ? Icon(Icons.chevron_right) : null,
      title: Text(capitalize(alignmentInfo.name)),
      color: Get.theme.canvasColor.withOpacity(selected != false ? 1 : 0.7),
      subtitle: alignmentInfo.description != null
          ? Text(alignmentInfo.description)
          : null,
      onTap: onTap,
    );
  }

  IconData get icon => chr.ALIGNMENT_ICON_MAP[alignment];
}
