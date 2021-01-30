import 'package:dungeon_paper/db/models/campaign.dart';
import 'package:flutter/material.dart';

enum CampaignCardMode {
  fixed,
  editable,
}

class CampaignCard extends StatelessWidget {
  final Campaign campaign;

  const CampaignCard({
    Key key,
    @required this.campaign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(campaign.name),
        children: [],
      ),
    );
  }
}
