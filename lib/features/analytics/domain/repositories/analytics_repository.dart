import 'package:pokedex_serasa/features/analytics/domain/entities/analytics_event.dart';

abstract class AnalyticsRepository {
  Future<void> logEvent(AnalyticsEvent event);
  Future<void> logScreenView(String screenName, String screenClass);
  Future<void> logPokemonView(
    int pokemonId,
    String pokemonName, {
    List<String>? types,
  });
  Future<void> logSearch(String searchTerm, {int? resultsCount});
  Future<void> logFilterApplied(List<String> types, {String? sortBy});
}
