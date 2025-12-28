import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex_serasa/core/network/dio_client.dart';
import 'package:pokedex_serasa/features/pokemons/data/datasources/pokemons_local_datasource.dart';
import 'package:pokedex_serasa/features/pokemons/data/datasources/pokemons_local_datasource_impl.dart';
import 'package:pokedex_serasa/features/pokemons/data/datasources/pokemons_remote_datasource.dart';
import 'package:pokedex_serasa/features/pokemons/data/datasources/pokemons_remote_datasource_impl.dart';
import 'package:pokedex_serasa/features/pokemons/data/repositories/pokemons_repository_impl.dart';
import 'package:pokedex_serasa/features/pokemons/domain/repositories/pokemons_repository.dart';
import 'package:pokedex_serasa/features/pokemons/domain/usecases/get_pokemons.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemons_list/pokemons_list_cubit.dart';
import 'package:pokedex_serasa/features/splash/presentation/pages/splash_page.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/pages/pokemons_list_page.dart';

class AppModule extends Module {
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

        dio.interceptors.add(
          LogInterceptor(
            requestBody: true,
            requestHeader: true,
            error: true,
            logPrint: (log) => print('[DIO] $log'),
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

    i.addLazySingleton(() => PokemonsListCubit(getPokemons: i()));
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
  }
}
