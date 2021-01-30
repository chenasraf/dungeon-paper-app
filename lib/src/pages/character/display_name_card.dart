import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisplayNameCard extends StatelessWidget {
  final TextEditingController controller;

  const DisplayNameCard({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Character name',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: TextStyle(
                    fontSize: Get.theme.textTheme.subtitle1.fontSize,
                  ),
                  hintText: "Your character's name",
                ),
                style: TextStyle(
                  fontSize: Get.theme.textTheme.headline6.fontSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
