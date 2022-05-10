import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:rick_and_morty/src/contracts/ICharacters_api.dart';
import 'package:rick_and_morty/src/models/DTO/character.dart';
import 'package:rick_and_morty/src/models/filter.dart';

class HomeBloc extends ChangeNotifier {
  HomeBloc({required this.charactersHttpService}) {
    _loadData();
  }

  final ICharactersApi charactersHttpService;

  AllCharacters? allCharacters;
  List<Character>? characters;
  bool loading = true;
  bool showFavourites = false;
  String? lastSearch;
  int currentPage = 1;
  late int totalPages;
  List<int> favourites = [];

  void _loadData() async {
    showLoading(true);
    try {
      allCharacters = await charactersHttpService.getAllCharacters();
      characters = allCharacters!.results!;
      totalPages = allCharacters!.info!.pages!;
    } catch (e) {
      log(e.toString());
    }
    showLoading(false);
  }

  void searchCharacter() async {
    showLoading(true);
    try {
      currentPage = 1;
      allCharacters = await charactersHttpService
          .getCharactersFilter(Filter(name: lastSearch, page: currentPage));
      characters = allCharacters!.results!;
      totalPages = allCharacters!.info!.pages!;
    } catch (e) {
      log(e.toString());
    }
    showLoading(false);
  }

  void nextPage() async {
    if (currentPage < totalPages) {
      showLoading(true);
      try {
        currentPage++;
        allCharacters = await charactersHttpService
            .getCharactersFilter(Filter(name: lastSearch, page: currentPage));
        characters = allCharacters!.results!;
      } catch (e) {
        log(e.toString());
      }
      showLoading(false);
    }
  }

  void prevPage() async {
    if (currentPage >= 1) {
      showLoading(true);
      try {
        currentPage--;
        allCharacters = await charactersHttpService
            .getCharactersFilter(Filter(name: lastSearch, page: currentPage));
        characters = allCharacters!.results!;
      } catch (e) {
        log(e.toString());
      }
      showLoading(false);
    }
  }

  void favourite(Character character) {
    if (favourites.contains(character.id)) {
      favourites.remove(character.id);
    } else {
      favourites.add(character.id!);
    }
    notifyListeners();
  }

  void changeShowFavourites() {
    showFavourites = !showFavourites;
    if (showFavourites) {
      characters = allCharacters!.results!
          .where((e) => favourites.contains(e.id))
          .toList();
    } else {
      characters = allCharacters!.results!;
    }
    notifyListeners();
  }

  void showLoading(bool ld) {
    loading = ld;
    notifyListeners();
  }
}
