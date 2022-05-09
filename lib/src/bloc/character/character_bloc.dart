import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:rick_and_morty/src/contracts/ICharacters_api.dart';
import 'package:rick_and_morty/src/contracts/IEpisodes_api.dart';
import 'package:rick_and_morty/src/models/DTO/character.dart';
import 'package:rick_and_morty/src/models/DTO/episode.dart';
import 'package:rick_and_morty/src/providers/constants.dart';

class CharacterBloc extends ChangeNotifier {
  CharacterBloc(
      {required this.episodesHttpService,
      required this.charactersHttpService,
      required this.character}) {
    _loadData();
  }

  final ICharactersApi charactersHttpService;
  final IEpisodesApi episodesHttpService;
  final Character character;
  List<Episode> listEpisodes = [];
  List<Character> listInterestingCharacters = [];

  void _loadData() {
    _loadEpisodes();
    _loadInterestingCharacters();
  }

  void _loadEpisodes() async {
    int count = Constants.maxEpisodes;
    if (character.episode!.length < 4) {
      count = character.episode!.length;
    }
    for (var i = 0; i < count; i++) {
      Episode episode =
          await episodesHttpService.getEpisode(character.episode![i]);
      listEpisodes.add(episode);
    }
    notifyListeners();
  }

  void _loadInterestingCharacters() async {
    List<int> ids = [];
    Random random = Random();
    for (var i = 0; i <= Constants.nInterestingCharacters - 1; i++) {
      int rn = random.nextInt(800) + 1;
      if (!ids.contains(rn)) {
        ids.add(rn);
      }
    }

    listInterestingCharacters =
        await charactersHttpService.getMultipleCharacters(ids);
    notifyListeners();
  }

  void showMore() {}
}
