import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_serasa/core/errors/exceptions.dart';
import 'package:pokedex_serasa/core/network/dio_client.dart';
import 'package:pokedex_serasa/features/pokemons/data/datasources/pokemons_remote_datasource_impl.dart';
import 'package:pokedex_serasa/features/pokemons/data/models/pokemon_model.dart';

import '../../../../helpers/fixture_reader.dart';

class MockRestClient extends Mock implements RestClient {}

void main() {
  late PokemonsRemoteDatasourceImpl datasource;
  late MockRestClient mockRestClient;

  setUp(() {
    mockRestClient = MockRestClient();
    datasource = PokemonsRemoteDatasourceImpl(restClient: mockRestClient);
  });

  group('getPokemons', () {
    final tPokemonsJson = json.decode(fixture('pokemons_response_fixture.json'));

    test('should perform a GET request on /pokedex.json', () async {
      when(() => mockRestClient.get(any())).thenAnswer(
        (_) async => Response(
          data: tPokemonsJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      await datasource.getPokemons();

      verify(() => mockRestClient.get('/pokedex.json')).called(1);
    });

    test('should return List<PokemonModel> when the call is successful', () async {
      when(() => mockRestClient.get(any())).thenAnswer(
        (_) async => Response(
          data: tPokemonsJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await datasource.getPokemons();

      expect(result, isA<List<PokemonModel>>());
      expect(result.length, 2);
      expect(result[0].name, 'Bulbasaur');
      expect(result[1].name, 'Ivysaur');
    });

    test('should throw NetworkException when DioException occurs', () async {
      when(() => mockRestClient.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'Network error',
        ),
      );

      final call = datasource.getPokemons();

      expect(call, throwsA(isA<NetworkException>()));
    });

    test('should throw NetworkException on generic exception', () async {
      when(() => mockRestClient.get(any())).thenThrow(Exception('Unexpected error'));

      final call = datasource.getPokemons();

      expect(call, throwsA(isA<NetworkException>()));
    });
  });
}
