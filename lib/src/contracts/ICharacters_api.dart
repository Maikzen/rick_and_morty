import 'package:rock_and_morty/src/models/filter.dart';

import '../models/DTO/character.dart';

abstract class ICharactersApi {
  Future<AllCharacters> getAllCharacters();
  Future<Character> getCharacter(int id);
  Future<List<Character>> getMultipleCharacters(List<int> ids);
  Future<AllCharacters> getCharactersFilter(Filter filter);
}
