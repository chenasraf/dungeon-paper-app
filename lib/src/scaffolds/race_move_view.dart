import 'package:dungeon_paper/src/builders/custom_move_form_builder.dart';
import 'package:dungeon_paper/src/dialogs/dialogs.dart';
import 'package:dungeon_world_data/move.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RaceMoveViewArguments {
  final Move move;
  final void Function(Move move) onSave;

  RaceMoveViewArguments({
    this.move,
    this.onSave,
  });
}

class RaceMoveView extends StatefulWidget {
  const RaceMoveView({
    Key key,
    @required this.move,
    @required this.mode,
    @required this.onSave,
  }) : super(key: key);

  final Move move;
  final DialogMode mode;
  final void Function(Move move) onSave;

  @override
  RaceMoveViewState createState() => RaceMoveViewState();
}

class RaceMoveViewState extends State<RaceMoveView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CustomMoveFormBuilder(
      mode: widget.mode,
      move: widget.move,
      onSave: widget.onSave,
      moveLabel: 'Race',
      builder: (ctx, form, onSave) {
        var appBar = AppBar(
          title: Text(
              '${widget.mode == DialogMode.create ? 'Add' : 'Edit'} Race Move'),
          actions: <Widget>[
            IconButton(
              tooltip: 'Save',
              icon: Icon(Icons.save),
              onPressed: onSave,
            ),
          ],
        );

        return Scaffold(
          appBar: appBar,
          body: SingleChildScrollView(
            child: Container(
              color: Get.theme.canvasColor,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: form,
              ),
            ),
          ),
        );
      },
    );
  }
}
