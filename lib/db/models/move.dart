import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:dungeon_world_data/move.dart';
import 'character.dart';

ReturnPredicate<Move> matchMove =
    matcher<Move>((Move i, Move o) => i.key == o.key);

Future updateMove(Character character, Move move) async {
  await character
      .copyWith(moves: findAndReplaceInList(character.moves, move))
      .update(keys: ['moves']);
}

Future deleteMove(Character character, Move move) async {
  await character
      .copyWith(moves: removeFromList(character.moves, move))
      .update(keys: ['moves']);
}

Future createMove(Character character, Move move) async {
  await character
      .copyWith(moves: addToList(character.moves, move))
      .update(keys: ['moves']);
}
