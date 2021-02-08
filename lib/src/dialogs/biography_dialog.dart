import 'package:dungeon_paper/db/models/character.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

class BiographyDialog extends StatelessWidget {
  final Character character;

  const BiographyDialog({
    Key key,
    @required this.character,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasBio = character.bio?.isNotEmpty == true;
    final hasClsDescr = character.playerClass?.description?.isNotEmpty == true;
    final hasLooks = character.looks.isNotEmpty;
    final blocks = <List<Widget>>[
      if (hasBio)
        [
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              'Character biography',
              textScaleFactor: 1.1,
              style: Get.theme.textTheme.bodyText2
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          MarkdownBody(
            data: character.bio,
            listItemCrossAxisAlignment:
                MarkdownListItemCrossAxisAlignment.start,
          ),
        ],
      if (hasLooks)
        [
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              'Appearance',
              textScaleFactor: 1.1,
              style: Get.theme.textTheme.bodyText2
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Text(character.looks.join(', ')),
        ],
      if (hasClsDescr)
        [
          // ExpansionTile(
          //   tilePadding: EdgeInsets.zero,
          //   title:
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              '${character.playerClass.name} description',
              textScaleFactor: 1.1,
              style: Get.theme.textTheme.bodyText2
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          // children: [
          MarkdownBody(
            data: character.playerClass.description,
            listItemCrossAxisAlignment:
                MarkdownListItemCrossAxisAlignment.start,
          ),
          // ],
          // )
        ]
    ];
    return SimpleDialog(
      title: Text('Biography'),
      contentPadding: const EdgeInsets.all(24),
      children: [
        for (var block in blocks) ...[
          ...block,
          SizedBox(height: 30),
        ]
      ],
    );
  }
}
