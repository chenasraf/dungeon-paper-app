import 'package:dungeon_paper/src/atoms/expandable_list.dart';
import 'package:dungeon_paper/src/controllers/characters_controller.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';

typedef BuilderAnyFunction<T, E> = E Function(T category, num index);
typedef BuilderFunction<T> = Widget Function(
    BuildContext context, T category, num itemIndex);
typedef KeyBuilderFunction<T> = String Function(
    BuildContext context, T category, num itemIndex);
typedef BuilderFunctionWithCatIndex<T> = Widget Function(
    BuildContext context, T category, num itemIndex, num catIndex);

class FlexibleColumns<T> extends StatefulWidget {
  final Iterable<T> items;
  final BuilderFunctionWithCatIndex<T> itemBuilder;
  final BuilderFunction<T> titleBuilder;
  final KeyBuilderFunction<T> keyBuilder;
  final BuilderAnyFunction<T, int> itemCount;
  final bool staggered;
  final double bottomSpacerHeight;
  final double topSpacerHeight;
  final EdgeInsets itemMargin;
  final ScrollController scrollController;

  FlexibleColumns({
    Key key,
    List<T> children,
    this.titleBuilder,
    @required this.keyBuilder,
    this.topSpacerHeight = 0.0,
    this.bottomSpacerHeight = 0.0,
    this.staggered = true,
    this.itemMargin = _defaultItemMargin,
    this.scrollController,
  })  : items = children,
        itemBuilder = null,
        itemCount = null,
        super(key: key);

  FlexibleColumns.builder({
    Key key,
    @required this.items,
    @required this.itemCount,
    @required this.itemBuilder,
    @required this.keyBuilder,
    this.titleBuilder,
    this.staggered = true,
    this.topSpacerHeight = 0.0,
    this.bottomSpacerHeight = 0.0,
    this.itemMargin = _defaultItemMargin,
    this.scrollController,
  }) : super(key: key);

  static const _defaultItemMargin = EdgeInsets.symmetric(horizontal: 16);

  @override
  _FlexibleColumnsState<T> createState() => _FlexibleColumnsState<T>();
}

class _FlexibleColumnsState<T> extends State<FlexibleColumns<T>> {
  final String sessionKey = Uuid().v4();

  bool get _isChildrenBuilder =>
      widget.itemBuilder == null || widget.itemCount == null;

  TextStyle titleStyle(BuildContext context) => Get.theme.textTheme.bodyText2
      .copyWith(fontSize: 16.0, fontWeight: FontWeight.bold);

  int get bottomSpacerCount =>
      clamp01(widget.bottomSpacerHeight.toInt()).toInt();

  int get topSpacerCount => clamp01(widget.topSpacerHeight.toInt()).toInt();

  @override
  Widget build(BuildContext context) {
    final origTheme = Get.theme;

    return OrientationBuilder(
      // key: PageStorageKey('$sessionKey: $sessionKey'),
      builder: (context, orientation) {
        return Theme(
          data: origTheme.copyWith(
            dividerColor: Colors.transparent,
            unselectedWidgetColor: titleStyle(context).color,
          ),
          child: LayoutBuilder(
            builder: _layoutBuilder(),
          ),
        );
      },
    );
  }

  void Function(BuildContext, BoxConstraints) _layoutBuilder() {
    return (context, constraints) {
      final cats = _itemsToWidgets(context);
      return StaggeredGridView.countBuilder(
        crossAxisCount: constraints.maxWidth < 450 ? 1 : 2,
        controller: widget.scrollController,
        itemCount: cats.length + bottomSpacerCount + topSpacerCount,
        itemBuilder: _itemWrapperBuilder,
        staggeredTileBuilder: (index) =>
            index < topSpacerCount || (index - 1 >= cats.length)
                ? StaggeredTile.fit(2)
                : StaggeredTile.fit(1),
      );
    };
  }

  Widget _itemWrapperBuilder(context, index) {
    final cats = _itemsToWidgets(context);
    if (index < topSpacerCount) {
      return SizedBox(height: widget.topSpacerHeight);
    }
    index -= topSpacerCount;
    if (index < cats.length) {
      final child = cats.elementAt(index);
      if (child != null) {
        return Padding(
          padding: widget.itemMargin,
          child: child,
        );
      }
      return Container();
    }
    return SizedBox(height: widget.bottomSpacerHeight);
  }

  List<Widget> _itemsToWidgets(BuildContext context) {
    return enumerate(widget.items)
        .map((item) => _itemBuilder(context, item.index, item.value))
        .toList();
  }

  Widget _itemBuilder(BuildContext context, int index, T item) {
    final origTheme = Get.theme;
    final builtTitle = widget.titleBuilder?.call(context, item, index);
    final titleTextStyle = titleStyle(context).copyWith(
      color: Get.theme.colorScheme.secondary,
    );
    final count = _isChildrenBuilder ? 1 : widget.itemCount(item, index);
    final outputItems = List<Widget>.generate(
      count,
      (j) => Theme(
        data: origTheme,
        child: _isChildrenBuilder
            ? item
            : widget.itemBuilder(context, item, j, index),
      ),
    );

    final builtKey = widget.keyBuilder?.call(context, item, index);
    final charId = characterController.current?.documentID;
    final title = builtTitle != null
        ? DefaultTextStyle(
            child: builtTitle,
            style: titleTextStyle,
          )
        : null;

    if (outputItems.isEmpty) {
      return Container();
    }

    return ExpandableList(
      key: PageStorageKey('$sessionKey-$index-$charId-expansion'),
      expansionKey: builtKey,
      title: title,
      children: outputItems,
    );
  }
}
