import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlatformSvg extends StatelessWidget {
  final String uri;
  final num width;
  final num height;
  final BoxFit fit;
  final Color color;
  final Alignment alignment;
  final String semanticsLabel;

  /// Overrides width & height;
  final num size;
  static final webHack = kIsWeb && !kDebugMode;

  PlatformSvg({
    Key key,
    @required this.uri,
    this.width,
    this.height,
    this.size,
    this.fit = BoxFit.contain,
    this.color,
    this.alignment = Alignment.center,
    this.semanticsLabel,
  }) : super(key: key);

  factory PlatformSvg.asset(
    String assetName, {
    num width,
    num height,
    num size,
    BoxFit fit = BoxFit.contain,
    Color color,
    Alignment alignment = Alignment.center,
    String semanticsLabel,
  }) =>
      PlatformSvg(
        uri: webHack ? 'assets/assets/$assetName' : 'assets/$assetName',
        width: width,
        height: height,
        size: size,
        fit: fit,
        color: color,
        alignment: alignment,
        semanticsLabel: semanticsLabel,
      );

  num get _width => size ?? width;
  num get _height => size ?? height;

  @override
  Widget build(BuildContext context) {
    final _color = color ?? IconTheme.of(context).color;
    if (webHack) {
      return Image.network(
        uri,
        width: _width.toDouble(),
        height: _height.toDouble(),
        fit: fit,
        color: _color,
        alignment: alignment,
        semanticLabel: semanticsLabel,
      );
    }

    return SvgPicture.asset(
      uri,
      width: _width.toDouble(),
      height: _height.toDouble(),
      fit: fit,
      color: _color,
      alignment: alignment,
      semanticsLabel: semanticsLabel,
    );
  }
}
