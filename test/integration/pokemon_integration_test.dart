import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_serasa/core/network/dio_client.dart';
import 'package:pokedex_serasa/features/pokemons/data/datasources/pokemons_local_datasource.dart';
import 'package:pokedex_serasa/features/pokemons/data/datasources/pokemons_local_datasource_impl.dart';
import 'package:pokedex_serasa/features/pokemons/data/datasources/pokemons_remote_datasource.dart';
import 'package:pokedex_serasa/features/pokemons/data/datasources/pokemons_remote_datasource_impl.dart';
import 'package:pokedex_serasa/features/pokemons/data/repositories/pokemons_repository_impl.dart';
import 'package:pokedex_serasa/features/pokemons/domain/repositories/pokemons_repository.dart';
import 'package:pokedex_serasa/features/pokemons/domain/usecases/get_pokemons.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemons_list/pokemons_list_cubit.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemons_list/pokemons_list_state.dart';

import '../helpers/fixture_reader.dart';

class MockRestClient extends Mock implements RestClient {}
class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  group('Pokemon Integration Tests', () {
    late PokemonsListCubit cubit;
    late GetPokemons getPokemons;
    late PokemonsRepository repository;
    late PokemonsRemoteDatasource remoteDatasource;
    late PokemonsLocalDatasource localDatasource;
    late MockRestClient mockRestClient;
    late MockAssetBundle mockAssetBundle;

    setUp(() {
      mockRestClient = MockRestClient();
      mockAssetBundle = MockAssetBundle();

      remoteDatasource = PokemonsRemoteDatasourceImpl(restClient: mockRestClient);
      localDatasource = PokemonsLocalDatasourceImpl(assetBundle: mockAssetBundle);
      repository = PokemonsRepositoryImpl(
        remoteDatasource: remoteDatasource,
        localDatasource: localDatasource,
      );
      getPokemons = GetPokemons(repository: repository);
      cubit = PokemonsListCubit(getPokemons: getPokemons);
    });

    tearDown(() {
      cubit.close();
    });

    test('should complete full flow from API to Cubit when remote succeeds', () async {
      // Arrange
      final jsonResponse = {
        'pokemon': [
          {
            'id': 1,
            'num': '001',
            'name': 'Bulbasaur',
            'img': 'http://test.png',
            'type': ['Grass', 'Poison'],
            'height': '0.71 m',
            'weight': '6.9 kg',
            'candy': 'Candy',
            'egg': '2 km',
            'spawn_chance': 0.69,
            'avg_spawns': 69,
            'spawn_time': '20:00',
            'weaknesses': ['Fire'],
          },
        ],
      };

      when(() => mockRestClient.get(any())).thenAnswer(
        (_) async => Response(
          data: jsonResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Act
      await cubit.loadPokemons();

      // Assert
      expect(cubit.state, isA<PokemonsListSuccess>());
      final successState = cubit.state as PokemonsListSuccess;
      expect(successState.pokemons.length, 1);
      expect(successState.pokemons[0].name, 'Bulbasaur');
      
      verify(() => mockRestClient.get('/pokedex.json')).called(1);
    });

    test('should use local data when remote fails (offline-first strategy)', () async {
      // Arrange
      when(() => mockRestClient.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'Network error',
        ),
      );

      final localJson = fixture('pokemons_response_fixture.json');
      when(() => mockAssetBundle.loadString(any())).thenAnswer((_) async => localJson);

      // Act
      await cubit.loadPokemons();

      // Assert
      expect(cubit.state, isA<PokemonsListSuccess>());
      final successState = cubit.state as PokemonsListSuccess;
      expect(successState.pokemons.length, 2);
      expect(successState.pokemons[0].name, 'Bulbasaur');
      expect(successState.pokemons[1].name, 'Ivysaur');
      
      verify(() => mockRestClient.get('/pokedex.json')).called(1);
      verify(() => mockAssetBundle.loadString('assets/resource/pokemons.json')).called(1);
    });

    test('should return error when both remote and local fail', () async {
      // Arrange
      when(() => mockRestClient.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'Network error',
        ),
      );
      when(() => mockAssetBundle.loadString(any())).thenThrow(
        Exception('File not found'),
      );

      // Act
      await cubit.loadPokemons();

      // Assert
      expect(cubit.state, isA<PokemonsListError>());
    });
  });
}
