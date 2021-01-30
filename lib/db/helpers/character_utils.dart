import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:flutter/material.dart';

enum AlignmentName {
  good,
  lawful,
  neutral,
  chaotic,
  evil,
}

const AlignmentMap = {
  AlignmentName.good: 'good',
  AlignmentName.lawful: 'lawful',
  AlignmentName.neutral: 'neutral',
  AlignmentName.chaotic: 'chaotic',
  AlignmentName.evil: 'evil',
};

// ignore: non_constant_identifier_names
final Map<String, AlignmentName> AlignmentNameMap = invertMap(AlignmentMap);

enum CharacterStat { str, dex, int, wis, cha, con }

const StatNameMap = {
  CharacterStat.str: 'Strength',
  CharacterStat.dex: 'Dexterity',
  CharacterStat.int: 'Intelligence',
  CharacterStat.wis: 'Wisdom',
  CharacterStat.cha: 'Charisma',
  CharacterStat.con: 'Constitution',
};

enum CharacterKey {
  alignment,
  displayName,
  mainClass,
  photoURL,
  level,
  currentHP,
  currentXP,
  maxHP,
  useDefaultMaxHP,
  armor,
  moves,
  notes,
  spells,
  inventory,
  docVersion,
  hitDice,
  looks,
  race,
  coins,
  lastUpdateDt,
}

const int MAX_STAT_VALUE = 18;

const List<CharacterStat> ORDERED_STATS = [
  CharacterStat.str,
  CharacterStat.dex,
  CharacterStat.con,
  CharacterStat.int,
  CharacterStat.wis,
  CharacterStat.cha,
];

const Map<CharacterStat, String> CHARACTER_STAT_LABELS = {
  CharacterStat.str: 'Strength',
  CharacterStat.dex: 'Dexterity',
  CharacterStat.con: 'Constitution',
  CharacterStat.wis: 'Wisdom',
  CharacterStat.int: 'Intelligence',
  CharacterStat.cha: 'Charisma',
};

const Map<CharacterStat, String> CHARACTER_STAT_KEYS = {
  CharacterStat.str: 'str',
  CharacterStat.dex: 'dex',
  CharacterStat.con: 'con',
  CharacterStat.wis: 'wis',
  CharacterStat.int: 'int',
  CharacterStat.cha: 'cha',
};

const Map<CharacterStat, String> CHARACTER_STAT_MODIFIER_LABELS = {
  CharacterStat.str: 'STR',
  CharacterStat.dex: 'DEX',
  CharacterStat.con: 'CON',
  CharacterStat.wis: 'WIS',
  CharacterStat.int: 'INT',
  CharacterStat.cha: 'CHA',
};

const Map<AlignmentName, IconData> ALIGNMENT_ICON_MAP = {
  AlignmentName.good: Icons.mood,
  AlignmentName.lawful: Icons.sentiment_satisfied,
  AlignmentName.neutral: Icons.sentiment_neutral,
  AlignmentName.chaotic: Icons.sentiment_dissatisfied,
  AlignmentName.evil: Icons.mood_bad,
};
