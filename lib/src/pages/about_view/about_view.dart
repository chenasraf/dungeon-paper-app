import 'dart:io';
import 'dart:math';
import 'package:dungeon_paper/src/atoms/flexible_columns.dart';
import 'package:dungeon_paper/src/atoms/feedback_button.dart';
import 'package:dungeon_paper/src/atoms/paypal_donate_button.dart';
import 'package:dungeon_paper/src/atoms/version_number.dart';
import 'package:dungeon_paper/src/flutter_utils/platform_svg.dart';
import 'package:dungeon_paper/src/pages/whats_new_view/whats_new_view.dart';
import 'package:dungeon_paper/src/scaffolds/main_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

const iconsCredits = [
  'ibrandify',
  'Freepik',
  'FontAwesome',
  'Skoll',
  'Delapouite',
  'iconmonstr',
  'Icon8',
];

class AboutView extends StatefulWidget {
  @override
  _AboutViewState createState() => _AboutViewState();
}

final num year = DateTime.now().year;
final utm = 'utm_medium=app&utm_source=about';

class _AboutViewState extends State<AboutView> {
  ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: Text('About Dungeon Paper'),
      wrapWithScrollable: false,
      scrollController: scrollController,
      body: FlexibleColumns(
        keyBuilder: null,
        scrollController: scrollController,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AppInfoBox(),
              SizedBox(height: 16),
              ContactUsBox()
            ],
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0).copyWith(top: 0),
            child: Column(
              children: <Widget>[
                Text('Credits', style: Get.theme.textTheme.headline6),
                SizedBox(height: 10.0),
                Text('Icons', style: Get.theme.textTheme.subtitle2),
                for (String credit in iconsCredits)
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Text(credit)),
                if (kIsWeb || !Platform.isIOS)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      "\"I'm a humble dev,\nmaking this at night alone;\ncould you spare some coin?\"",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Get.theme.textTheme.caption.color),
                      textScaleFactor: 0.7,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0).copyWith(top: 0),
                  child: DonateButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppInfoBox extends StatelessWidget {
  const AppInfoBox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AboutBox(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: SizedBox.fromSize(
            size: Size.square(min(Get.mediaQuery.size.width - 32, 128)),
            child: Image.asset('assets/logo.png'),
          ),
        ),
        Text(
          'Dungeon Paper',
          style: Get.theme.textTheme.headline5,
        ),
        VersionNumber.text(prefix: 'Version'),
        SizedBox(height: 16),
        RaisedButton.icon(
          icon: Icon(Icons.history),
          label: Text('Changelog'),
          onPressed: () => Get.dialog(WhatsNew.dialog()),
        ),
        SizedBox(height: 16),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Develeoped by '),
              TextSpan(
                text: 'Chen Asraf',
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launch('https://casraf.blog/?$utm'),
                style: TextStyle(
                  color: Color.fromRGBO(25, 118, 210, 1),
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
        Text('© 2018-$year'),
      ],
    );
  }
}

class SocialButton extends StatelessWidget {
  final String label;
  final String assetName;
  final Widget icon;
  final Color color;
  final Color textColor;
  final String url;
  final double textScaleFactor;

  const SocialButton({
    Key key,
    @required this.label,
    this.assetName,
    this.icon,
    @required this.color,
    this.textColor,
    @required this.url,
    this.textScaleFactor = 1,
  })  : assert(icon != null || assetName != null),
        super(key: key);

  static const double SOCIAL_ICON_SIZE = 24;

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      icon: Container(
        width: SOCIAL_ICON_SIZE,
        child: assetName != null
            ? PlatformSvg.asset(
                'social/$assetName.svg',
                width: SOCIAL_ICON_SIZE,
                height: SOCIAL_ICON_SIZE,
                color: textColor,
              )
            : icon,
      ),
      color: color,
      textColor: textColor,
      label: Expanded(
        child: Center(
          child: Text(
            label,
            textScaleFactor: 1.25 * (textScaleFactor ?? 1),
          ),
        ),
      ),
      onPressed: () => launch(url),
    );
  }
}

class AboutBox extends StatelessWidget {
  final Widget child;
  final List<Widget> children;

  const AboutBox({
    Key key,
    this.child,
    this.children,
  })  : assert(child != null || children != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = children != null && children.isNotEmpty
        ? Column(
            children: children,
          )
        : child;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: content,
      ),
    );
  }
}

class ContactUsBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AboutBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Have feedback? Want to stay up to date?\nFollow or contact us at:',
            textAlign: TextAlign.center,
            style: Get.theme.textTheme.subtitle1,
          ),
          SizedBox(height: 8),
          Table(
            columnWidths: {
              0: FlexColumnWidth(1),
              1: FixedColumnWidth(14),
              2: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                children: [
                  SocialButton(
                    assetName: 'facebook',
                    label: 'Facebook',
                    color: Color(0xFF1878F3),
                    textColor: Colors.white,
                    url: 'https://bit.ly/DungeonPaper-Facebook',
                  ),
                  Container(),
                  SocialButton(
                    label: 'Twitter',
                    assetName: 'twitter',
                    color: Color(0xFF00ACEE),
                    textColor: Colors.white,
                    url: 'https://bit.ly/DungeonPaper-Twitter',
                  ),
                ],
              ),
              TableRow(
                children: [
                  SocialButton(
                    label: 'GitHub',
                    url: 'https://bit.ly/DungeonPaper-GitHub',
                    assetName: 'github',
                    color: Colors.black,
                    textColor: Colors.white,
                  ),
                  Container(),
                  SocialButton(
                    label: 'Discord',
                    url: 'https://bit.ly/DungeonPaper-Discord',
                    assetName: 'discord',
                    color: Color(0xFF7289DB),
                    textColor: Colors.white,
                  ),
                ],
              ),
              TableRow(
                children: [
                  FeedbackButton(
                    dontWaitForUser: true,
                    builder: (onPressed, url) => SocialButton(
                      label: 'Email',
                      icon: Icon(Icons.email),
                      url: url,
                      color: Colors.orange[300],
                      textColor: Get.theme.colorScheme.onPrimary,
                    ),
                  ),
                  Container(),
                  SocialButton(
                    label: 'Privacy',
                    icon: Icon(Icons.lock),
                    url: 'https://bit.ly/DungeonPaper-Privacy',
                    color: Get.theme.primaryColor,
                    textColor: Get.theme.colorScheme.onPrimary,
                  ),
                ],
              ),
              TableRow(
                children: [
                  SocialButton(
                    label: 'Website',
                    url: 'https://dungeonpaper.app/?$utm',
                    icon: Icon(Icons.public),
                    color: Color(0xFFFFFFFF),
                    textColor: Colors.black,
                    textScaleFactor: 0.9,
                  ),
                  Container(),
                  SocialButton(
                    label: 'Review',
                    url: Platform.isIOS
                        ? 'https://apps.apple.com/us/app/dungeon-paper/id1525383509'
                        : 'https://play.google.com/store/apps/details?id=app.dungeonpaper&$utm',
                    icon: Icon(Icons.star),
                    color: Color(0xFF66A030),
                    textColor: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
