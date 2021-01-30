import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/src/dialogs/dialogs.dart';
import 'package:dungeon_paper/src/flutter_utils/widget_utils.dart';
import 'package:dungeon_paper/src/molecules/avatar_upload_card.dart';
import 'package:dungeon_paper/src/pages/character/bio_card.dart';
import 'package:dungeon_paper/src/pages/character/display_name_card.dart';
import 'package:dungeon_paper/src/utils/types.dart';
import 'package:flutter/material.dart';

class EditBasicInfoView extends StatefulWidget {
  final Character character;
  final VoidCallbackDelegate<Character> onUpdate;
  final DialogMode mode;
  final ValueNotifier validityNotifier;

  const EditBasicInfoView({
    Key key,
    @required this.onUpdate,
    this.mode = DialogMode.edit,
    this.character,
    this.validityNotifier,
  }) : super(key: key);

  @override
  _EditBasicInfoViewState createState() => _EditBasicInfoViewState();
}

enum _Keys { displayName, photoURL, bio }

class _EditBasicInfoViewState extends State<EditBasicInfoView> {
  static Widget spacer = SizedBox(height: 10.0);
  Map<_Keys, TextEditingController> editingControllers;

  @override
  void initState() {
    editingControllers = WidgetUtils.textEditingControllerMap(list: [
      EditingControllerConfig(
        key: _Keys.displayName,
        defaultValue: widget.character.displayName,
        listener: () {
          var def = widget.character.copyWith(
            displayName: editingControllers[_Keys.displayName].text.trim(),
          );
          updateWith(def);
        },
      ),
      EditingControllerConfig(
        key: _Keys.photoURL,
        defaultValue: widget.character.photoURL,
        listener: () {
          var def = widget.character.copyWith(
            photoURL: editingControllers[_Keys.photoURL].text.trim(),
          );
          updateWith(def);
        },
      ),
      EditingControllerConfig(
        key: _Keys.bio,
        defaultValue: widget.character.bio,
        listener: () {
          var def = widget.character.copyWith(
            bio: editingControllers[_Keys.bio].text.trim(),
          );
          updateWith(def);
        },
      ),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DisplayNameCard(
              controller: editingControllers[_Keys.displayName],
            ),
            spacer,
            AvatarUploadCard(
              character: widget.character,
              controller: editingControllers[_Keys.photoURL],
              onSave: (char) {
                updateWith(
                  widget.character.copyWith(
                    customSettings: char.settings,
                  ),
                );
              },
            ),
            spacer,
            BioCard(
              controller: editingControllers[_Keys.bio],
            ),
          ],
        ),
      ),
    );
  }

  bool _isValid() => editingControllers[_Keys.displayName].text.isNotEmpty;

  void updateWith(Character def) {
    widget.validityNotifier?.value = _isValid();
    widget?.onUpdate?.call(def);
  }
}
