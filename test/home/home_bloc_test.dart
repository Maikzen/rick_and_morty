import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rick_and_morty/src/bloc/home/home_bloc.dart';
import 'package:rick_and_morty/src/contracts/ICharacters_api.dart';
import 'package:rick_and_morty/src/models/DTO/character.dart';
import 'package:rick_and_morty/src/models/filter.dart';

import 'home_bloc_test.mocks.dart';

@GenerateMocks([ICharactersApi])
main() {
  final charactersMock = MockICharactersApi();
  final HomeBloc homeBloc = HomeBloc(charactersHttpService: charactersMock);

  test('Home bloc getCharacters empty is ok', () async {
    when(charactersMock.getAllCharacters())
        .thenAnswer((_) async => AllCharacters.empty());

    AllCharacters allCharacters = await homeBloc.getCharacters();

    expect(allCharacters.results, []);
  });

  test('Home bloc getCharactersFilters empty is ok', () async {
    Filter filter = Filter(name: 'XXXXXXXXXXX');
    when(charactersMock.getCharactersFilter(filter))
        .thenAnswer((_) async => AllCharacters.empty());

    AllCharacters allCharacters = await homeBloc.getCharacters(filter: filter);

    expect(allCharacters.results, []);
  });

  test('Home bloc getCharacters contains is ok', () async {
    when(charactersMock.getAllCharacters())
        .thenAnswer((_) async => AllCharacters.fromJson(jsonTest));

    AllCharacters allCharacters = await homeBloc.getCharacters();

    expect(allCharacters.results, isNotEmpty);
  });

  test('Home bloc getCharactersFilters contains is ok', () async {
    Filter filter = Filter(name: 'XXXXXXXXXXX');
    when(charactersMock.getCharactersFilter(filter))
        .thenAnswer((_) async => AllCharacters.fromJson(jsonTest));

    AllCharacters allCharacters = await homeBloc.getCharacters(filter: filter);

    expect(allCharacters.results, isNotEmpty);
  });
}

var jsonTest = {
  "info": {"count": 3, "pages": 1, "next": null, "prev": null},
  "results": [
    {
      "id": 534,
      "name": "Tony's Dad",
      "status": "Alive",
      "species": "Alien",
      "type": "",
      "gender": "Male",
      "origin": {"name": "unknown", "url": ""},
      "location": {
        "name": "Earth (Replacement Dimension)",
        "url": "https://rickandmortyapi.com/api/location/20"
      },
      "image": "https://rickandmortyapi.com/api/character/avatar/534.jpeg",
      "episode": ["https://rickandmortyapi.com/api/episode/33"],
      "url": "https://rickandmortyapi.com/api/character/534",
      "created": "2020-05-02T13:52:06.880Z"
    },
    {
      "id": 541,
      "name": "Secretary at Tony's",
      "status": "Alive",
      "species": "Alien",
      "type": "",
      "gender": "Female",
      "origin": {"name": "unknown", "url": ""},
      "location": {
        "name": "Earth (Replacement Dimension)",
        "url": "https://rickandmortyapi.com/api/location/20"
      },
      "image": "https://rickandmortyapi.com/api/character/avatar/541.jpeg",
      "episode": ["https://rickandmortyapi.com/api/episode/33"],
      "url": "https://rickandmortyapi.com/api/character/541",
      "created": "2020-05-02T13:57:49.250Z"
    },
    {
      "id": 725,
      "name": "Tony Galopagus",
      "status": "Alive",
      "species": "Human",
      "type": "",
      "gender": "Male",
      "origin": {
        "name": "Earth (Replacement Dimension)",
        "url": "https://rickandmortyapi.com/api/location/20"
      },
      "location": {
        "name": "Earth (Replacement Dimension)",
        "url": "https://rickandmortyapi.com/api/location/20"
      },
      "image": "https://rickandmortyapi.com/api/character/avatar/725.jpeg",
      "episode": ["https://rickandmortyapi.com/api/episode/44"],
      "url": "https://rickandmortyapi.com/api/character/725",
      "created": "2021-10-17T10:01:10.143Z"
    }
  ]
};
