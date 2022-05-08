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
  String? lastSearch;
  int currentPage = 1;
  late int totalPages;

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
      allCharacters = await charactersHttpService
          .getCharactersFilter(Filter(name: lastSearch));
      characters = allCharacters!.results!;
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
            .getCharactersFilter(Filter(page: currentPage));
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
            .getCharactersFilter(Filter(page: currentPage));
        characters = allCharacters!.results!;
      } catch (e) {
        log(e.toString());
      }
      showLoading(false);
    }
  }

  void showLoading(bool ld) {
    loading = ld;
    notifyListeners();
  }
}
