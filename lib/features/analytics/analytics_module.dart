import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex_serasa/core/platform/analytics_channel.dart';
import 'package:pokedex_serasa/core/platform/analytics_channel_impl.dart';
import 'package:pokedex_serasa/core/platform/analytics_constants.dart';
import 'package:pokedex_serasa/features/analytics/data/datasources/analytics_native_datasource.dart';
import 'package:pokedex_serasa/features/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:pokedex_serasa/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_event_usecase.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_filter_usecase.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_pokemon_view_usecase.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_screen_view_usecase.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_search_usecase.dart';

class AnalyticsModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.addSingleton<MethodChannel>(
      () => const MethodChannel(AnalyticsConstants.channelName),
    );

    i.addSingleton<AnalyticsChannel>(
      () => AnalyticsChannelImpl(channel: i.get()),
    );

    i.addSingleton<AnalyticsNativeDataSource>(
      () => AnalyticsNativeDataSource(channel: i.get()),
    );

    i.addSingleton<AnalyticsRepository>(
      () => AnalyticsRepositoryImpl(nativeDataSource: i.get()),
    );

    i.addSingleton(() => LogEventUseCase(repository: i.get()));
    i.addSingleton(() => LogFilterUseCase(repository: i.get()));
    i.addSingleton(() => LogPokemonViewUseCase(repository: i.get()));
    i.addSingleton(() => LogScreenViewUseCase(repository: i.get()));
    i.addSingleton(() => LogSearchUseCase(repository: i.get()));
  }
}
