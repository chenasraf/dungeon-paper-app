import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';

class VersionNumber extends StatefulWidget {
  final Widget Function(Version version) builder;

  const VersionNumber({
    Key key,
    @required this.builder,
  }) : super(key: key);

  factory VersionNumber.text({Key key, String prefix, String suffix}) =>
      VersionNumber(
        key: key,
        builder: (v) => Text(
            [prefix, v.toString(), suffix].where((s) => s != null).join(' ')),
      );

  @override
  _VersionNumberState createState() => _VersionNumberState();
}

class _VersionNumberState extends State<VersionNumber> {
  Version version;

  @override
  void initState() {
    super.initState();
    _getVersion();
  }

  void _getVersion() async {
    var packageInfo = await PackageInfo.fromPlatform();

    if (mounted) {
      setState(() {
        version =
            Version.parse('${packageInfo.version}+${packageInfo.buildNumber}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (version == null) {
      return Container();
    }
    return widget.builder(version);
  }
}
