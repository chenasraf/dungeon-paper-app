import 'dart:math';

import 'package:dungeon_paper/src/dialogs/standard_dialog_controls.dart';
import 'package:dungeon_paper/src/flutter_utils/widget_utils.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:dungeon_paper/src/utils/changelog.dart';
import 'package:get/get.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsNew extends StatefulWidget {
  final Widget Function(BuildContext context, Widget child) builder;

  const WhatsNew({
    Key key,
    this.builder,
  }) : super(key: key);

  WhatsNew.withScaffold({
    Key key,
  })  : builder = scaffoldBuilder,
        super(key: key);

  WhatsNew.dialog({
    Key key,
  })  : builder = dialogBuilder,
        super(key: key);

  static Widget dialogBuilder(BuildContext context, Widget child) {
    return AlertDialog(
      title: Text('Changelog'),
      titlePadding: EdgeInsets.all(24).copyWith(bottom: 16),
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: min(400, MediaQuery.of(context).size.height),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 32),
            child: child,
          ),
        ),
      ),
      actions: StandardDialogControls.actions(
        context: context,
        onConfirm: () => Get.back(),
        confirmText: Text('Got it!'),
      ),
    );
  }

  static Widget scaffoldBuilder(BuildContext context, Widget child) {
    return Scaffold(
      backgroundColor: Get.theme.canvasColor,
      appBar: AppBar(
        title: Text('Changelog'),
      ),
      body: SingleChildScrollView(child: child),
    );
  }

  @override
  _WhatsNewState createState() => _WhatsNewState();
}

class _WhatsNewState extends State<WhatsNew> {
  Map<Version, ChangelogContent> changelog;
  String changelogUrl;
  Version currentVersion;
  bool error = false;

  @override
  void initState() {
    _initChangelog();
    _getCurrentVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (currentVersion == null || changelog == null) {
      if (!error) {
        child = Container(
          width: min(320, MediaQuery.of(context).size.width),
          height: min(400, MediaQuery.of(context).size.height),
          child: Center(
            child: Loader(color: Get.theme.colorScheme.primary),
          ),
        );
      } else {
        child = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Text(
              'Looks like we had a problem fetching the changelog. Try later!'),
        );
      }
    } else {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var data in enumerate(mapped(currentVersion))) ...[
                  if (data.index > 0) Divider(height: 64),
                  MarkdownBody(
                    data: data.value,
                    onTapLink: (text, url, _title) => launch(url),
                    listItemCrossAxisAlignment:
                        MarkdownListItemCrossAxisAlignment.start,
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    }

    if (widget.builder != null) return widget.builder(context, child);
    return child;
  }

  List<String> mapped(Version ver) {
    if (changelog == null) return [];
    if (changelog[ver] == null) {
      ver = changelog.keys.firstWhere((k) => k <= ver);
    }
    const LIMIT = 3;
    var verIdx = changelog.keys.toList().indexOf(ver);
    var versions = changelog.keys.toList();

    if (verIdx > 0) versions.removeRange(0, verIdx);

    return versions.take(LIMIT).map(_verString).toList();
  }

  String _verString(Version v) {
    var prefix = v == currentVersion ? '' : 'Previous ';
    return '## ${prefix}Version ${changelog[v].title}\n\n' +
        changelog[v].lines.join('\n') +
        '\n\n';
  }

  void _initChangelog() async {
    await _getSecrets();
    await _getChangelog();
  }

  void _getCurrentVersion() async {
    var packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      currentVersion = Version.parse(packageInfo.version);
    });
  }

  Future<void> _getSecrets() async {
    var secrets = await loadSecrets();
    changelogUrl = secrets.GITHUB_CHANGELOG_URL;
  }

  Future<void> _getChangelog() async {
    var client = http.Client();
    var res = await client.get(Uri.parse(changelogUrl));
    if (res.statusCode != 200) {
      if (mounted) {
        setState(() {
          error = true;
        });
      }
      return;
    }
    if (mounted) {
      setState(() {
        changelog = ChangelogParser.parseString(res.body);
      });
    }
  }
}
