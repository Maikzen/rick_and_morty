import 'package:flutter/cupertino.dart';
import 'package:rick_and_morty/src/contracts/ICharacters_api.dart';
import 'package:rick_and_morty/src/models/DTO/character.dart';
import 'package:rick_and_morty/src/models/filter.dart';

class HomeBloc extends ChangeNotifier {
  HomeBloc({required this.charactersHttpService}) {
    _init();
  }

  final ICharactersApi charactersHttpService;

  TextEditingController searchTextController = TextEditingController();

  AllCharacters? allCharacters;
  List<Character>? characters;
  bool loading = true;
  bool showFavourites = false;
  Filter filter = Filter(page: 1);
  bool showFilters = false;
  String? genderValue;

  void _init() async {
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    showLoading(true);
    allCharacters = await getCharacters();
    characters = allCharacters!.results!;
    showLoading(false);
  }

  Future<AllCharacters> getCharacters({Filter? filter}) async {
    try {
      if (filter == null) {
        return await charactersHttpService.getAllCharacters();
      } else {
        return await charactersHttpService.getCharactersFilter(filter);
      }
    } catch (e) {
      return AllCharacters.empty();
    }
  }

  void favourite(Character character) {
    if (character.fav == true) {
      characters![characters!.indexOf(character)].fav = false;
    } else {
      characters![characters!.indexOf(character)].fav = true;
    }
    notifyListeners();
  }

  void changeShowFavourites() {
    showFavourites = !showFavourites;
    if (showFavourites) {
      characters = characters!.where((e) => e.fav == true).toList();
    } else {
      characters = allCharacters!.results!;
    }
    notifyListeners();
  }

  void showLoading(bool ld) {
    loading = ld;
    notifyListeners();
  }

  void toggleMenu() {
    showFilters = !showFilters;
    notifyListeners();
  }
}
