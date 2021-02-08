import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/db/models/inventory_item.dart';
import 'package:dungeon_world_data/dw_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('Character', () {
    final wizard = dungeonWorld.classes.firstWhere((k) => k.key == 'wizard');
    final druid = dungeonWorld.classes.firstWhere((k) => k.key == 'druid');
    final immolator =
        dungeonWorld.classes.firstWhere((k) => k.key == 'immolator');

    test('generates default uuid key', () {
      final char1 = Character(key: Uuid().v4(), playerClass: immolator);
      final char2 = Character.fromJson(<String, dynamic>{});

      expect(char1.key, isNotNull);
      expect(char2.key, isNotNull);
      expect(char1.key, isNotEmpty);
      expect(char2.key, isNotEmpty);
    });

    test('properly uses class values', () {
      final char = Character.fromJson(
        <String, dynamic>{
          'playerClass': wizard.toJSON().cast<String, dynamic>(),
          'con': 10,
        },
      );
      expect(char.playerClass.key, equals(wizard.key));
      expect(char.currentHP, equals(wizard.baseHP + char.constitution));
      expect(char.maxHP, equals(wizard.baseHP + char.constitution));
    });

    test('properly dumps json', () {
      final char = Character.fromJson(
        <String, dynamic>{
          'playerClass': druid.toJSON().cast<String, dynamic>(),
          'displayName': 'Goku',
          'str': 20,
          'dex': 10,
          'int': 8,
          'wis': 11,
          'con': 10,
          'cha': 14,
        },
      );
      final json = char.toJson();
      expect(json['alignment'], equals('neutral'));
      expect(json['displayName'], equals('Goku'));
      expect(json['playerClass']['key'], equals('druid'));
      expect(json['hitDice'], equals('1d6'));
    });

    test('auto max HP get/set', () {
      var char1 = Character.fromJson(
        <String, dynamic>{
          'playerClass':
              immolator.toJSON().cast<String, dynamic>(), // base HP 6
          'displayName': 'Goku',
          'str': 20,
          'dex': 10,
          'int': 8,
          'wis': 11,
          'con': 10, // mod = 0
          'cha': 14,
          'settings': {'useDefaultMaxHp': true},
        },
      );
      var char2 = Character.fromJson(
        <String, dynamic>{
          'playerClass': wizard.toJSON().cast<String, dynamic>(), // base HP 4
          'displayName': 'Harry Potter',
          'str': 20,
          'dex': 10,
          'int': 8,
          'wis': 11,
          'con': 16,
          'cha': 14,
          'settings': {'useDefaultMaxHp': true},
        },
      );
      expect(char1.maxHP, equals(immolator.baseHP + char1.constitution));
      expect(char2.maxHP, equals(wizard.baseHP + char2.constitution));

      char1 = char1.copyWith(constitution: 16); // +1 mod
      char2 = char2.copyWith(constitution: 10); // 0 mod
      expect(char1.maxHP, equals(immolator.baseHP + char1.constitution));
      expect(char2.maxHP, equals(wizard.baseHP + char2.constitution));
    });
  });

  group('Character tag calculations', () {
    test('weight calc', () {
      final itemWithWeight = InventoryItem(
        key: Uuid().v4(),
        name: '',
        tags: [
          Tag('weight', 1),
        ],
      );

      expect(itemWithWeight.hasWeight, isTrue);
      expect(itemWithWeight.weight, equals(1));
    });
    test('armor calc', () {
      final itemWithWeight = InventoryItem(
        key: Uuid().v4(),
        name: '',
        tags: [
          Tag('armor', 1),
        ],
      );

      expect(itemWithWeight.hasArmor, isTrue);
      expect(itemWithWeight.armor, equals(1));
    });
    test('damage calc', () {
      final itemWithWeight = InventoryItem(
        key: Uuid().v4(),
        name: '',
        tags: [
          Tag('damage', 1),
        ],
      );

      expect(itemWithWeight.hasDamage, isTrue);
      expect(itemWithWeight.damage, equals(1));
    });
  });

  group('Character migrations', () {
    group('Settings migration', () {
      group('useDefaultMaxHP', () {
        test('no current value', () {
          final char1 = Character.fromJson(<String, dynamic>{
            'useDefaultMaxHP': true,
          });

          expect(char1.settings.useDefaultMaxHp, equals(true));
        });
        test('value different from default', () {
          final char2 = Character.fromJson(<String, dynamic>{
            'useDefaultMaxHP': true,
            'settings': {'useDefaultMaxHp': false},
          });

          expect(char2.settings.useDefaultMaxHp, equals(false));
        });

        test('value set and changed but has lingering old data', () {
          final char3 = Character.fromJson(<String, dynamic>{
            'useDefaultMaxHP': false,
            'settings': {'useDefaultMaxHp': false}
          });

          expect(char3.settings.useDefaultMaxHp, equals(false));
        });
      });
    });
  });
}
