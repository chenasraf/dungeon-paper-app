import 'package:dungeon_paper/components/animations/slide_route_from_right.dart';
import 'package:dungeon_paper/components/confirmation_dialog.dart';
import 'package:dungeon_paper/db/character.dart';
import 'package:dungeon_paper/db/character_types.dart' as Chr;
import 'package:dungeon_paper/profile_view/basic_info/change_alignment_dialog.dart';
import 'package:dungeon_paper/profile_view/basic_info/change_class_dialog.dart';
import 'package:dungeon_paper/redux/stores/stores.dart';
import 'package:dungeon_paper/utils.dart';
import 'package:dungeon_world_data/player_class.dart';
import 'package:dungeon_world_data/alignment.dart' as DWA;
import 'package:flutter/material.dart';

class EditCharacterDialog extends StatefulWidget {
  final DbCharacter character;

  const EditCharacterDialog({
    Key key,
    @required this.character,
  }) : super(key: key);

  @override
  _EditCharacterDialogState createState() => _EditCharacterDialogState();
}

class _EditCharacterDialogState extends State<EditCharacterDialog> {
  String photoURL;
  String displayName;
  TextEditingController photoURLController;
  TextEditingController displayNameController;
  static Widget spacer = SizedBox(height: 10.0);
  ScrollController scrollController = ScrollController();
  double appBarElevation = 0.0;

  @override
  void initState() {
    photoURL = widget.character.photoURL ?? '';
    displayName = widget.character.displayName ?? '';

    scrollController.addListener(scrollListener);

    photoURLController =
        TextEditingController.fromValue(TextEditingValue(text: photoURL))
          ..addListener(photoURLListener);

    displayNameController =
        TextEditingController.fromValue(TextEditingValue(text: displayName))
          ..addListener(displayNameListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    photoURLController.removeListener(photoURLListener);
    displayNameController.removeListener(displayNameListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Edit Character Details'),
            elevation: appBarElevation,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Save'),
                  color: Theme.of(context).canvasColor,
                  onPressed: formValid() ? save : null,
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    EditDisplayNameCard(controller: displayNameController),
                    spacer,
                    EditAvatarCard(controller: photoURLController),
                    spacer,
                    ClassSmallDescription(
                        playerClass: widget.character.mainClass,
                        level: widget.character.level,
                        onTap: () => changeClass(context)),
                    spacer,
                    AlignmentDescription(
                        playerClass: widget.character.mainClass,
                        alignment: widget.character.alignment,
                        onTap: () => changeAlignment(context)),
                    spacer,
                    dwStore.state.characters.characters.length > 1
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: FlatButton(
                              // color: Colors.red,
                              textColor: Colors.red,
                              child: Text('Delete Character'),
                              onPressed:
                                  dwStore.state.characters.characters.isNotEmpty
                                      ? () async {
                                          if (await showDialog(
                                            context: context,
                                            builder: (context) =>
                                                ConfirmationDialog(
                                                  title:
                                                      Text('Delete Character?'),
                                                  text: Text(
                                                      'THIS CAN NOT BE UNDONE!\nAre you sure this is what you want to do?'),
                                                  okButtonText: Text(
                                                      'I WANT THIS CHARACTER GONE!'),
                                                  cancelButtonText: Text(
                                                      'I regret clicking this'),
                                                ),
                                          )) {
                                            deleteCharacter();
                                            await Future.delayed(Duration(milliseconds: 1000));
                                            Navigator.pop(context);
                                          }
                                        }
                                      : null,
                            ),
                          )
                        : SizedBox.shrink()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool formValid() {
    return <bool>[
      displayName != null && displayName.length > 0,
    ].every((cond) => cond);
  }

  void save() {
    DbCharacter character = widget.character;
    character.displayName = displayName;
    character.photoURL = photoURL;
    updateCharacter(
      character,
      [CharacterKeys.displayName, CharacterKeys.photoURL],
    );
    Navigator.pop(context);
  }

  void changeClass(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, anim, anim2) => ChangeClassDialog(),
        transitionsBuilder: (context, inAnim, outAnim, child) {
          return SlideRouteFromRight(
            inAnim: inAnim,
            outAnim: outAnim,
            child: ChangeClassDialog(),
          );
        },
      ),
    );
  }

  void changeAlignment(BuildContext context) async {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, anim, anim2) => ChangeAlignmentDialog(
              playerClass: widget.character.mainClass,
            ),
        transitionsBuilder: (context, inAnim, outAnim, child) {
          return SlideRouteFromRight(
            inAnim: inAnim,
            outAnim: outAnim,
            child: ChangeAlignmentDialog(
              playerClass: widget.character.mainClass,
            ),
          );
        },
      ),
    );
  }

  void displayNameListener() {
    setState(() {
      displayName = displayNameController.text;
    });
  }

  void photoURLListener() {
    setState(() {
      photoURL = photoURLController.text;
    });
  }

  void scrollListener() {
    double newElevation = scrollController.offset > 16.0 ? 1.0 : 0.0;
    if (newElevation != appBarElevation) {
      setState(() {
        appBarElevation = newElevation;
      });
    }
  }
}

class EditAvatarCard extends StatefulWidget {
  final TextEditingController controller;
  final Function() onSave;

  const EditAvatarCard({
    Key key,
    @required this.controller,
    this.onSave,
  }) : super(key: key);

  @override
  _EditAvatarCardState createState() => _EditAvatarCardState();
}

class _EditAvatarCardState extends State<EditAvatarCard> {
  bool imageError = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).canvasColor,
      elevation: 1.0,
      type: MaterialType.card,
      borderRadius: BorderRadius.circular(5.0),
      child: Column(
        children: <Widget>[
          avatar(),
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(top: 0.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.url,
                    enableInteractiveSelection: true,
                    decoration: InputDecoration(
                      hintText: 'We recommend uploading to imgur.com',
                      labelText: 'Avatar Image URL',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget avatar() {
    // var image = NetworkImageWithRetry(widget.controller.text,
    //     fetchStrategy: (uri, failure) async {
    //       print('ahem');
    //   if (failure != null) {
    //     await Future.delayed(Duration(microseconds: 1));
    //     setState(() {
    //       imageError = true;
    //     });
    //     return FetchInstructions.giveUp(uri: uri);
    //   } else {
    //     setState(() {
    //       imageError = false;
    //     });
    //     return NetworkImageWithRetry.defaultFetchStrategy(uri, failure);
    //   }
    // });
    var image = NetworkImage(widget.controller.text);
    var container = AspectRatio(
      aspectRatio: 14.0 / 9.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            alignment: FractionalOffset.topCenter,
            image: image,
          ),
        ),
      ),
    );
    var placeholder = Container(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Text(!imageError
            ? 'Add an image URL in the field below.'
            : "We couldn't load your image,\nPlease check the URL and try again."),
      ),
    );
    return widget.controller.text.length == 0 || imageError == true
        ? placeholder
        : container;
  }
}

class EditDisplayNameCard extends StatelessWidget {
  final TextEditingController controller;

  const EditDisplayNameCard({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).canvasColor,
      elevation: 1.0,
      type: MaterialType.card,
      borderRadius: BorderRadius.circular(5.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0).copyWith(top: 0.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Character name',
                  labelStyle: TextStyle(
                    fontSize: Theme.of(context).textTheme.subhead.fontSize,
                  ),
                  hintText: "Your character's name",
                ),
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.title.fontSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClassSmallDescription extends StatelessWidget {
  final PlayerClass playerClass;
  final VoidCallback onTap;
  final int level;

  const ClassSmallDescription({
    Key key,
    @required this.playerClass,
    this.level,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).canvasColor,
      elevation: 1.0,
      type: MaterialType.card,
      borderRadius: BorderRadius.circular(5.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(Icons.person, size: 40.0),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      (level != null ? "Level $level " : "") + playerClass.name,
                      style: Theme.of(context).textTheme.title,
                    ),
                    Text(
                      'Change class',
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class AlignmentDescription extends StatelessWidget {
  final PlayerClass playerClass;
  final Chr.Alignment alignment;
  final VoidCallback onTap;
  final int level;

  const AlignmentDescription({
    Key key,
    @required this.playerClass,
    @required this.alignment,
    this.level,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String alignmentKey = enumName(alignment);
    DWA.Alignment alignmentInfo = playerClass.alignments[alignmentKey] ??
        DWA.Alignment(alignmentKey, alignmentKey, '');
    bool hasDescription = alignmentInfo.description.isNotEmpty;

    List<Widget> texts = <Widget>[
      Text(
        capitalize(alignmentInfo.name),
        style: Theme.of(context).textTheme.title,
      ),
    ];
    if (hasDescription) {
      texts.add(Text(
        alignmentInfo.description,
        style: Theme.of(context).textTheme.body1,
      ));
    }
    return Material(
      color: Theme.of(context).canvasColor,
      elevation: 1.0,
      type: MaterialType.card,
      borderRadius: BorderRadius.circular(5.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(icon, size: 40.0),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: texts,
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  get icon {
    switch (alignment) {
      case Chr.Alignment.good:
        return Icons.mood;
      case Chr.Alignment.lawful:
        return Icons.sentiment_satisfied;
      case Chr.Alignment.neutral:
        return Icons.sentiment_neutral;
      case Chr.Alignment.chaotic:
        return Icons.sentiment_dissatisfied;
      case Chr.Alignment.evil:
        return Icons.mood_bad;
    }
  }
}