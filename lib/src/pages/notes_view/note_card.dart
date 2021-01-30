import 'package:dungeon_paper/db/models/note.dart';
import 'package:dungeon_paper/src/atoms/card_bottom_controls.dart';
import 'package:dungeon_paper/src/dialogs/confirmation_dialog.dart';
import 'package:dungeon_paper/src/flutter_utils/widget_utils.dart';
import 'package:dungeon_paper/src/lists/tag_list.dart';
import 'package:dungeon_paper/src/scaffolds/note_view.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final List<String> categories;
  final void Function(Note) onSave;
  final void Function() onDelete;

  NoteCard({
    Key key,
    @required this.note,
    @required this.onSave,
    @required this.onDelete,
    @required this.categories,
  }) : super(key: key);

  @override
  NoteCardState createState() => NoteCardState();
}

class NoteCardState extends State<NoteCard> {
  @override
  Widget build(BuildContext context) {
    var desc = widget.note.description;
    return Card(
      margin: EdgeInsets.zero,
      child: ExpansionTile(
        title: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.note.title),
            ],
          ),
        ),
        subtitle: widget.note.tags.isNotEmpty
            ? TagList(
                visualDensity: VisualDensity.compact,
                tags: widget.note.tags,
                textScaleFactor: 0.9,
              )
            : null,
        onExpansionChanged: (value) => analytics.logEvent(
          name: Events.ExpandNoteCard,
          parameters: {'state': value.toString()},
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: MarkdownBody(
              onTapLink: (text, url, _title) => _launchURL(url),
              data: desc.trim().isNotEmpty ? desc : 'This note has no content.',
              listItemCrossAxisAlignment:
                  MarkdownListItemCrossAxisAlignment.start,
            ),
          ),
          CardBottomControls(
            entityTypeName: 'Note',
            onEdit: () => editNote(context),
            onDelete: () => deleteCurrentNote(context),
          ),
        ],
      ),
    );
  }

  void editNote(BuildContext context) {
    Get.toNamed(
      '/edit-note',
      arguments: NoteViewArguments(
        note: widget.note,
        categories: widget.categories,
        onSave: (note) {
          widget.onSave?.call(note);
        },
      ),
    );
  }

  void deleteCurrentNote(BuildContext context) async {
    if (await showDialog(
          context: context,
          builder: (context) => ConfirmationDialog(
              title: const Text('Delete Note'),
              text: const Text('Are you sure?'),
              cancelButtonText: Text('Cancel')),
        ) ==
        true) {
      if (widget.onDelete != null) {
        widget.onDelete();
      }
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar(
        'Hmm...',
        "Couldn't launch URL. Is it well-formed?",
        duration: SnackBarDuration.short,
      );
    }
  }
}
