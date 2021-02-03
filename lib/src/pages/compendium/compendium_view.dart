import 'package:dungeon_paper/routes.dart';
import 'package:dungeon_paper/src/atoms/card_list_item.dart';
import 'package:dungeon_paper/src/scaffolds/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Compendium extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: Text('Compendium'),
      automaticallyImplyLeading: true,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            CardListItem(
              title: Text('Custom Classes'),
              leading: Icon(Icons.person),
              onTap: () {
                Get.toNamed(Routes.customClassesList.path);
              },
            )
          ],
        ),
      ),
    );
  }
}
