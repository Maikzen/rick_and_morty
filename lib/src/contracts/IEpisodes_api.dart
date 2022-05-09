import '../models/DTO/episode.dart';

abstract class IEpisodesApi {
  Future<Episode> getEpisode(String url);
}
