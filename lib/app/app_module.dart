import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex_serasa/core/network/dio_client.dart';
import 'package:pokedex_serasa/features/analytics/analytics_module.dart';
import 'package:pokedex_serasa/features/pokemons/data/datasources/pokemons_local_datasource.dart';
import 'package:pokedex_serasa/features/pokemons/data/datasources/pokemons_local_datasource_impl.dart';
import 'package:pokedex_serasa/features/pokemons/data/datasources/pokemons_remote_datasource.dart';
import 'package:pokedex_serasa/features/pokemons/data/datasources/pokemons_remote_datasource_impl.dart';
import 'package:pokedex_serasa/features/pokemons/data/repositories/pokemons_repository_impl.dart';
import 'package:pokedex_serasa/features/pokemons/domain/repositories/pokemons_repository.dart';
import 'package:pokedex_serasa/features/pokemons/domain/usecases/get_pokemons.dart';
import 'package:pokedex_serasa/features/pokemons/domain/usecases/search_pokemon.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemon_search/pokemon_search_cubit.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemons_list/pokemons_list_cubit.dart';
import 'package:pokedex_serasa/features/splash/presentation/pages/splash_page.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/pages/pokemons_list_page.dart';
import 'package:pokedex_serasa/features/pokemon_detail/presentation/pages/pokemon_detail_page.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [AnalyticsModule()];
  @override
  void binds(i) {
    i.addLazySingleton<Dio>(
      () {
        final dio = Dio(
          BaseOptions(
            baseUrl:
                'https://raw.githubusercontent.com/Biuni/PokemonGo-Pokedex/master',
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
          ),
        );

        return dio;
      },
    );

    i.addLazySingleton<RestClient>(
      () => DioClient(dio: i()),
    );

    i.addLazySingleton<PokemonsRemoteDatasource>(
      () => PokemonsRemoteDatasourceImpl(restClient: i()),
    );

    i.addLazySingleton<PokemonsLocalDatasource>(
      () => PokemonsLocalDatasourceImpl(assetBundle: rootBundle),
    );

    i.addLazySingleton<PokemonsRepository>(
      () => PokemonsRepositoryImpl(
        remoteDatasource: i(),
        localDatasource: i(),
      ),
    );

    i.addLazySingleton(() => GetPokemons(repository: i()));
    i.addLazySingleton(() => SearchPokemon(repository: i()));

    i.addLazySingleton(() => PokemonsListCubit(getPokemons: i()));
    i.addLazySingleton(() => PokemonSearchCubit(searchPokemon: i()));
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (_) => const SplashPage(),
    );
    r.child(
      '/pokemons/',
      child: (_) => const PokemonsListPage(),
    );
    r.child(
      '/pokemon-detail/',
      child: (_) {
        final args = r.args.data;
        if (args is Map) {
          return PokemonDetailPage(
            pokemon: args['pokemon'] as Pokemon,
            allPokemons: args['allPokemons'] as List<Pokemon>?,
          );
        }
        return PokemonDetailPage(
          pokemon: args as Pokemon,
        );
      },
    );
  }
}
