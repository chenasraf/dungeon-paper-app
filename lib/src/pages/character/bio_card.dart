import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BioCard extends StatelessWidget {
  final TextEditingController controller;

  const BioCard({Key key, this.controller}) : super(key: key);

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
                maxLines: null,
                minLines: 3,
                controller: controller,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Biography',
                  labelStyle: TextStyle(
                    fontSize: Get.theme.textTheme.subtitle1.fontSize,
                  ),
                  hintText: 'Tell us about your character.\n'
                      'Where it comes from, their motivation,\n'
                      'or anything you want.\n'
                      'Get creative!',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
