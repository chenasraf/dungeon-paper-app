import 'package:dungeon_paper/src/atoms/tag_chip.dart';
import 'package:dungeon_paper/src/dialogs/tag_dialog.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:dungeon_world_data/tag.dart';
import 'package:flutter/material.dart';

class EditableTagList extends StatelessWidget {
  final List<Tag> tags;
  final void Function(List<Tag> tag) onSave;

  const EditableTagList({
    Key key,
    List<Tag> tags,
    this.onSave,
  })  : tags = tags ?? const [],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 5.0,
      children: [
        for (num i = 0; i < tags.length; i++)
          if (tags[i]?.name != null)
            TagChip(
              tag: tags[i],
              onPressed: (tag) => openEditDialog(context, tag),
              onDelete: handleDelete(),
            ),
        TagChip(
          tag: null,
          onPressed: (tag) => openEditDialog(context, tag),
        ),
      ],
    );
  }

  void Function(Tag) handleDelete() {
    return (Tag tag) {
      if (onSave == null) return;
      onSave(
        removeFromList(tags, tag)..removeWhere((tag) => tag?.name == null),
      );
    };
  }

  void openEditDialog(BuildContext context, Tag tag) {
    showDialog(
      context: context,
      builder: (ctx) => TagDialog(
          tag: tag,
          onSave: (tag) {
            if (onSave == null) return;
            onSave(
              upsertIntoList(tags, tag)
                ..removeWhere((tag) => tag?.name == null),
            );
          }),
    );
  }
}
