import 'package:rick_and_morty/src/contracts/IEpisodes_api.dart';
import 'package:rick_and_morty/src/models/DTO/episode.dart';
import 'package:rick_and_morty/src/services/base_http_service.dart';

class EpisodesHttpService extends BaseHttpService implements IEpisodesApi {
  EpisodesHttpService() : super('');

  @override
  Future<Episode> getEpisode(String url) async {
    final response = await get(url);
    return Episode.fromJson(response);
  }
}
