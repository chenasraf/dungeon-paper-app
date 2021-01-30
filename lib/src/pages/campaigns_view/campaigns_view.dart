import 'package:dungeon_paper/src/scaffolds/main_scaffold.dart';
import 'package:flutter/material.dart';

class CampaignsView extends StatefulWidget {
  @override
  _CampaignsViewState createState() => _CampaignsViewState();
}

class _CampaignsViewState extends State<CampaignsView> {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: Text('Campaigns'),
      body: ListView(
        shrinkWrap: true,
        children: [
          Text('Managed by you'),
          Text('Participating in'),
        ],
      ),
    );
  }
}
