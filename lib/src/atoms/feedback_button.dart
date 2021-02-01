import 'package:dungeon_paper/src/atoms/hyperlink.dart';
import 'package:dungeon_paper/src/controllers/user_controller.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackButton extends StatefulWidget {
  final void Function() onPressed;
  final bool dontWaitForUser;
  final Widget Function(Function() onPressed, String mailtoUrl) builder;
  final Widget icon;
  final String labelText;
  final void Function() onReady;

  static const Icon feedbackIcon = Icon(Icons.feedback);
  static const feedbackLabel = 'Send Feedback';

  const FeedbackButton({
    Key key,
    @required this.builder,
    this.icon = feedbackIcon,
    this.labelText = feedbackLabel,
    this.onPressed,
    this.dontWaitForUser = false,
    this.onReady,
  }) : super(key: key);

  factory FeedbackButton.iconButton({
    Key key,
    Widget icon = feedbackIcon,
    String labelText = feedbackLabel,
    Function() onPressed,
    bool dontWaitForUser = false,
  }) =>
      FeedbackButton(
        key: key,
        onPressed: onPressed,
        dontWaitForUser: dontWaitForUser,
        builder: (onPressed, _) => IconButton(
          icon: icon,
          tooltip: labelText,
          onPressed: onPressed,
        ),
      );

  factory FeedbackButton.raisedButton({
    Key key,
    Widget icon = feedbackIcon,
    String labelText = feedbackLabel,
    Function() onPressed,
    bool dontWaitForUser = false,
  }) =>
      FeedbackButton(
        key: key,
        onPressed: onPressed,
        dontWaitForUser: dontWaitForUser,
        builder: (onPressed, _) => RaisedButton(
          child: Column(
            children: <Widget>[icon, Expanded(child: Text(labelText))],
          ),
          onPressed: onPressed,
        ),
      );

  factory FeedbackButton.listItem({
    Key key,
    Widget icon = feedbackIcon,
    String labelText = feedbackLabel,
    Function() onPressed,
    bool dontWaitForUser = false,
  }) =>
      FeedbackButton(
        key: key,
        onPressed: onPressed,
        dontWaitForUser: dontWaitForUser,
        builder: (onPressed, _) => ListTile(
          leading: icon,
          title: Text(labelText),
          onTap: onPressed,
        ),
      );

  factory FeedbackButton.hyperlink({
    Key key,
    String labelText = feedbackLabel,
    Function() onPressed,
    bool dontWaitForUser = false,
  }) =>
      FeedbackButton(
        key: key,
        onPressed: onPressed,
        dontWaitForUser: dontWaitForUser,
        builder: (_, mailtoUrl) => Hyperlink(text: labelText, url: mailtoUrl),
      );

  @override
  _FeedbackButtonState createState() => _FeedbackButtonState();
}

class _FeedbackButtonState extends State<FeedbackButton> {
  String userId;
  String email;
  String version;
  String buildNumber;

  final Widget icon = Icon(Icons.feedback);
  final String labelText = 'Send Feedback';

  @override
  void initState() {
    _getUserId();
    _getEmail();
    _getVersionData();
    super.initState();
  }

  void _getUserId() async {
    if (mounted) {
      setState(() {
        userId = userController.currentUserDocID;
        _notifyReady();
      });
    }
  }

  void _getEmail() async {
    var secrets = await loadSecrets();
    if (mounted) {
      setState(() {
        email = secrets['FEEDBACK_EMAIL'];
        _notifyReady();
      });
    }
  }

  void _getVersionData() async {
    var packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        version = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
        _notifyReady();
      });
    }
  }

  void _notifyReady() {
    if (isReady) {
      widget?.onReady?.call();
    }
  }

  String get subject => Uri.encodeComponent('Dungeon Paper Feedback');
  String get body => Uri.encodeComponent('''
    --- Dungeon Paper Version: $version / $buildNumber
    ''');
  String get mailtoUrl => 'mailto:$email?subject=$subject&body=$body';
  void sendEmail() => launch(mailtoUrl);
  void onPressed() {
    sendEmail();
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return Container();
    }
    return Container(
      child: widget.builder(onPressed, mailtoUrl),
    );
  }

  Iterable<String> get _arrRepr => [
        userId ?? (widget.dontWaitForUser ? 'true' : 'false'),
        email,
        version
      ].map((el) => el?.toString?.call() ?? '');

  // ignore: unused_element
  String get _strRepr => _arrRepr.join('-');

  bool get isReady => !_arrRepr.any((i) => i == 'false' || i == null);
}
