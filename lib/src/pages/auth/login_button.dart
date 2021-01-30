import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginButton extends StatelessWidget {
  // final void Function(UserLogin login) onUserChange;
  final void Function() onPressed;
  final String label;
  final Color color;
  final Color textColor;
  final Widget icon;

  LoginButton({
    Key key,
    @required this.onPressed,
    @required this.label,
    this.color,
    this.textColor,
    @required this.icon,
    // this.onUserChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 40,
      child: RaisedButton.icon(
        icon: icon,
        label: Expanded(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: textColor,
            ),
          ),
        ),
        color: color ?? Get.theme.accentColor,
        onPressed: onPressed,
      ),
    );
  }
}
