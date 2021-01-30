import 'package:dungeon_paper/db/models/custom_class.dart';
import 'package:dungeon_paper/src/atoms/card_list_item.dart';
import 'package:dungeon_paper/src/flutter_utils/widget_utils.dart';
import 'package:dungeon_paper/src/controllers/custom_classes_controller.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomClassesList extends StatelessWidget {
  final SingleChildWidgetBuilder builder;
  final void Function(CustomClass) onEdit;
  final void Function(CustomClass) onDelete;

  const CustomClassesList({
    Key key,
    this.onEdit,
    this.onDelete,
  })  : builder = null,
        super(key: key);

  const CustomClassesList.builder({
    Key key,
    this.builder,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  SingleChildWidgetBuilder get _builder => builder ?? (ctx, child) => child;

  @override
  Widget build(BuildContext context) {
    var child = Obx(
      () {
        final classes = customClassesController.classes.values.toList();
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var cls in classes)
                CardListItem(
                  onTap: () => onEdit?.call(cls),
                  leading: Icon(Icons.person, size: 40),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => onDelete?.call(cls),
                  ),
                  title: Text(cls.name),
                  subtitle: Text(_subtitle(cls)),
                ),
            ],
          ),
        );
      },
    );
    return _builder(context, child);
  }

  String _subtitle(CustomClass cls) {
    var _allMoves = cls.startingMoves + cls.advancedMoves1 + cls.advancedMoves2;
    var _alignments =
        cls.alignments.values.where((a) => a.description?.isNotEmpty);
    var counts = [
      if (cls.raceMoves.isNotEmpty) pluralize(cls.raceMoves.length, 'Race'),
      if (_allMoves.isNotEmpty) pluralize(_allMoves.length, 'Move'),
      if (_alignments.isNotEmpty) pluralize(_alignments.length, 'Alignment'),
    ];
    return counts.join(', ');
  }
}
