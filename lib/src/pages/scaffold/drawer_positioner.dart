import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerPositioner extends StatelessWidget {
  final Widget drawer;
  final Widget Function(Widget drawer) body;

  const DrawerPositioner({
    Key key,
    @required this.drawer,
    @required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usePermanentSidebar = Get.mediaQuery.size.width > 1200;
    if (usePermanentSidebar) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          drawer,
          Expanded(child: body(null)),
        ],
      );
    }
    return body(drawer);
  }
}
