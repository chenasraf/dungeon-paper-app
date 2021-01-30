import 'dart:math';

import 'package:dungeon_paper/src/flutter_utils/platform_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyState extends StatelessWidget {
  /// Path to SVG image in assets
  final String assetName;

  /// Custom image widget
  final Widget image;

  /// Top text (above image)
  final Widget title;

  /// Bottom text (below image)
  final Widget subtitle;

  final Color foregroundColor;

  const EmptyState({
    Key key,
    this.assetName,
    this.image,
    @required this.title,
    @required this.subtitle,
    this.foregroundColor,
  })  : assert(assetName != null || image != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var _fgColor = foregroundColor ?? Get.theme.accentColor;
    var imgSize = 80.toDouble();
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          DefaultTextStyle(
            child: title,
            style: Get.theme.textTheme.headline5.copyWith(color: _fgColor),
            textAlign: TextAlign.center,
          ),
          IconTheme.merge(
            data: IconThemeData(color: _fgColor),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: assetName != null
                  ? PlatformSvg.asset(
                      assetName,
                      size: imgSize,
                      alignment: Alignment.center,
                      color: _fgColor,
                    )
                  : image,
            ),
          ),
          Container(
            width: min(Get.mediaQuery.size.width, 260),
            child: DefaultTextStyle(
              child: subtitle,
              style: Get.theme.textTheme.headline6.copyWith(color: _fgColor),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
