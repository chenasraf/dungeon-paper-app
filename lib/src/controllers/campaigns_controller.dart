import 'package:dungeon_paper/db/models/campaign.dart';
import 'package:get/get.dart';

class CampaignsController extends GetxController {
  final RxMap<String, Campaign> _owned = <String, Campaign>{}.obs;
  final RxMap<String, Campaign> _participating = <String, Campaign>{}.obs;

  Map<String, Campaign> get owned => _owned;
  Map<String, Campaign> get participating => _participating;

  void upsertOwned(Campaign cls, [bool updateCondition = true]) {
    owned[cls.documentID] = cls;
    update(null, updateCondition);
  }

  void upsertParticipating(Campaign cls, [bool updateCondition = true]) {
    _participating[cls.documentID] = cls;
    update(null, updateCondition);
  }

  void removeOwned(Campaign cls, [bool updateCondition = true]) {
    owned.remove(cls.documentID);
    update(null, updateCondition);
  }

  void removeParticipating(Campaign cls, [bool updateCondition = true]) {
    _participating.remove(cls.documentID);
    update(null, updateCondition);
  }

  void setAllOwned(Iterable<Campaign> campaigns,
      [bool updateCondition = true]) {
    clearOwned(false);
    _owned.assignAll({
      for (final cls in campaigns) cls.documentID: cls,
    });
    update(null, updateCondition);
  }

  void setAllParticipating(Iterable<Campaign> campaigns,
      [bool updateCondition = true]) {
    clearParticipating(false);
    _participating.assignAll({
      for (final cls in campaigns) cls.documentID: cls,
    });
    update(null, updateCondition);
  }

  void clearOwned([bool updateCondition = true]) {
    _owned.removeWhere((_, __) => true);
    update(null, updateCondition);
  }

  void clearParticipating([bool updateCondition = true]) {
    _participating.removeWhere((_, __) => true);
    update(null, updateCondition);
  }

  void clearAll([bool updateCondition = true]) {
    clearOwned(false);
    clearParticipating(updateCondition);
  }
}

final campaignsController = CampaignsController();
