import '../repositories/analytics_repository.dart';

class LogPokemonViewUseCase {
  final AnalyticsRepository _repository;

  const LogPokemonViewUseCase({required AnalyticsRepository repository})
    : _repository = repository;

  Future<void> call({
    required int pokemonId,
    required String pokemonName,
    List<String>? types,
  }) async {
    await _repository.logPokemonView(
      pokemonId,
      pokemonName,
      types: types,
    );
  }
}
