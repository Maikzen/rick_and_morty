import 'package:rock_and_morty/src/contracts/ICharacters_api.dart';
import 'package:rock_and_morty/src/models/DTO/character.dart';
import 'package:rock_and_morty/src/models/filter.dart';
import 'package:rock_and_morty/src/providers/constants.dart';
import 'package:rock_and_morty/src/services/base_http_service.dart';

class CharactersHttpService extends BaseHttpService implements ICharactersApi {
  CharactersHttpService() : super(Constants.charactersPath);

  @override
  Future<AllCharacters> getAllCharacters() async {
    final response = await get(baseUrl);
    return AllCharacters.fromJson(response);
  }

  @override
  Future<Character> getCharacter(int id) async {
    final path = Constants.characterById.replaceAll('{id}', id.toString());
    final response = await get(baseUrl + path);
    return Character.fromJson(response);
  }

  @override
  Future<AllCharacters> getCharactersFilter(Filter filter) async {
    final response = await get(baseUrl, params: filter.toJson());
    return AllCharacters.fromJson(response);
  }

  @override
  Future<List<Character>> getMultipleCharacters(List<int> ids) {
    // TODO: implement getMultipleCharacters
    throw UnimplementedError();
  }
}
