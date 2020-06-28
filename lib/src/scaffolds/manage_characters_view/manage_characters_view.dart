import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/src/atoms/card_list_item.dart';
import 'package:dungeon_paper/src/dialogs/confirmation_dialog.dart';
import 'package:dungeon_paper/src/dialogs/dialogs.dart';
import 'package:dungeon_paper/src/dialogs/export_characters_dialog.dart';
import 'package:dungeon_paper/src/pages/character_wizard/character_wizard_view.dart';
import 'package:dungeon_paper/src/redux/characters/characters_store.dart';
import 'package:dungeon_paper/src/redux/stores.dart';
import 'package:dungeon_paper/src/scaffolds/scaffold_with_elevation.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';
import 'package:reorderables/reorderables.dart';

class ManageCharactersView extends StatefulWidget {
  @override
  _ManageCharactersViewState createState() => _ManageCharactersViewState();
}

class _ManageCharactersViewState extends State<ManageCharactersView> {
  List<Character> characters;
  ScrollController scrollController;

  @override
  void initState() {
    characters = dwStore.state.characters.characters.values.toList()
      ..sort((a, b) => a.order - b.order);
    scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithElevation.primaryBackground(
      title: Text('Manage Characters'),
      actions: [
        IconButton(
          icon: Icon(Icons.file_upload),
          onPressed: _openExportDialog,
          tooltip: 'Export Characters',
        ),
      ],
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).canvasColor,
        // foregroundColor: Theme.of(context).canvasColor,
        onPressed: _openCreatePage,
      ),
      automaticallyImplyLeading: true,
      body: ReorderableColumn(
        header: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Tip: Hold & drag a character to change its order.'),
        ),
        mainAxisSize: MainAxisSize.min,
        onReorder: _reorder,
        scrollController: scrollController,
        children: [
          for (var char in characters)
            IntrinsicWidth(
              key: Key(char.documentID),
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: CardListItem(
                  width: MediaQuery.of(context).size.width - 22,
                  title: Text(char.displayName),
                  leading: Icon(Icons.person, size: 40),
                  subtitle: Text(
                      'Level ${char.level} ${capitalize(enumName(char.alignment))} ${capitalize(char.mainClass.name)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        tooltip: 'Edit ${char.displayName}',
                        onPressed: () => _edit(char, context),
                      ),
                      IconButton(
                        color: Colors.red,
                        icon: Icon(Icons.delete_forever),
                        tooltip: 'Delete ${char.displayName}',
                        onPressed: () async {
                          if (await showDialog(
                            context: context,
                            builder: (context) => ConfirmationDialog(
                              title: Text('Delete Character?'),
                              text: Text(
                                  'THIS CAN NOT BE UNDONE!\nAre you sure this is what you want to do?'),
                              okButtonText: Text('I WANT THIS CHARACTER GONE!'),
                              cancelButtonText: Text('I regret clicking this'),
                            ),
                          )) {
                            dwStore.dispatch(RemoveCharacter(char));
                            await char.delete();
                            if (mounted) {
                              setState(() {
                                characters = characters..remove(char);
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _reorder(num oldIdx, num newIdx) {
    var copy = [...characters];
    var char = copy.elementAt(oldIdx);
    copy
      ..removeAt(oldIdx)
      ..insert(newIdx, char);
    for (var char in enumerate(copy)) {
      unawaited(char.value.update(json: {'order': char.index}));
    }
    setState(() {
      characters = [...copy];
    });
    dwStore.dispatch(
      SetCharacters(
        Map<String, Character>.fromEntries(
          copy.map((char) => MapEntry(char.documentID, char)),
        ),
      ),
    );
  }

  void _edit(Character char, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => CharacterWizardView(
          character: char,
          mode: DialogMode.Edit,
        ),
      ),
    );
  }

  void _openCreatePage() {
    Navigator.push(
      context,
      MaterialPageRoute<bool>(
        builder: (context) => CharacterWizardView(
          character: null,
          mode: DialogMode.Create,
        ),
      ),
    );
  }

  void _openExportDialog() {
    showDialog(
      context: context,
      builder: (context) => ExportCharactersDialog(),
    );
  }
}
