import 'package:flutter_modular/flutter_modular.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_serasa/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_event_usecase.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_filter_usecase.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_pokemon_view_usecase.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_screen_view_usecase.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_search_usecase.dart';

class MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

class TestModule extends Module {
  @override
  void binds(Injector i) {
    final mockRepository = MockAnalyticsRepository();

    when(
      () => mockRepository.logScreenView(
        any(),
        any(),
      ),
    ).thenAnswer((_) async => Future.value());

    when(
      () => mockRepository.logPokemonView(
        any(),
        any(),
        types: any(named: 'types'),
      ),
    ).thenAnswer((_) async => Future.value());

    when(
      () => mockRepository.logSearch(
        any(),
        resultsCount: any(named: 'resultsCount'),
      ),
    ).thenAnswer((_) async => Future.value());

    when(
      () => mockRepository.logFilterApplied(
        any(),
        sortBy: any(named: 'sortBy'),
      ),
    ).thenAnswer((_) async => Future.value());

    i.addSingleton<AnalyticsRepository>(() => mockRepository);
    i.addSingleton(() => LogEventUseCase(repository: i.get()));
    i.addSingleton(() => LogFilterUseCase(repository: i.get()));
    i.addSingleton(() => LogPokemonViewUseCase(repository: i.get()));
    i.addSingleton(() => LogScreenViewUseCase(repository: i.get()));
    i.addSingleton(() => LogSearchUseCase(repository: i.get()));
  }

  @override
  void exportedBinds(Injector i) {
    final mockRepository = MockAnalyticsRepository();

    when(
      () => mockRepository.logScreenView(
        any(),
        any(),
      ),
    ).thenAnswer((_) async => Future.value());

    when(
      () => mockRepository.logPokemonView(
        any(),
        any(),
        types: any(named: 'types'),
      ),
    ).thenAnswer((_) async => Future.value());

    when(
      () => mockRepository.logSearch(
        any(),
        resultsCount: any(named: 'resultsCount'),
      ),
    ).thenAnswer((_) async => Future.value());

    when(
      () => mockRepository.logFilterApplied(
        any(),
        sortBy: any(named: 'sortBy'),
      ),
    ).thenAnswer((_) async => Future.value());

    i.addSingleton<AnalyticsRepository>(() => mockRepository);
    i.addSingleton(() => LogEventUseCase(repository: i.get()));
    i.addSingleton(() => LogFilterUseCase(repository: i.get()));
    i.addSingleton(() => LogPokemonViewUseCase(repository: i.get()));
    i.addSingleton(() => LogScreenViewUseCase(repository: i.get()));
    i.addSingleton(() => LogSearchUseCase(repository: i.get()));
  }
}
