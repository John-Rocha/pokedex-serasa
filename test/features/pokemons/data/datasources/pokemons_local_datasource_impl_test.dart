import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_serasa/core/errors/exceptions.dart';
import 'package:pokedex_serasa/features/pokemons/data/datasources/pokemons_local_datasource_impl.dart';
import 'package:pokedex_serasa/features/pokemons/data/models/pokemon_model.dart';

import '../../../../helpers/fixture_reader.dart';

class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  late PokemonsLocalDatasourceImpl datasource;
  late MockAssetBundle mockAssetBundle;

  setUp(() {
    mockAssetBundle = MockAssetBundle();
    datasource = PokemonsLocalDatasourceImpl(assetBundle: mockAssetBundle);
  });

  group('getPokemons', () {
    final tJsonString = fixture('pokemons_response_fixture.json');

    test('should load pokemons from assets/resource/pokemons.json', () async {
      when(() => mockAssetBundle.loadString(any())).thenAnswer((_) async => tJsonString);

      await datasource.getPokemons();

      verify(() => mockAssetBundle.loadString('assets/resource/pokemons.json')).called(1);
    });

    test('should return List<PokemonModel> when loading is successful', () async {
      when(() => mockAssetBundle.loadString(any())).thenAnswer((_) async => tJsonString);

      final result = await datasource.getPokemons();

      expect(result, isA<List<PokemonModel>>());
      expect(result.length, 2);
      expect(result[0].name, 'Bulbasaur');
      expect(result[1].name, 'Ivysaur');
    });

    test('should throw FileException when asset loading fails', () async {
      when(() => mockAssetBundle.loadString(any())).thenThrow(Exception('Asset not found'));

      final call = datasource.getPokemons();

      expect(call, throwsA(isA<FileException>()));
    });

    test('should throw FileException on JSON parsing error', () async {
      when(() => mockAssetBundle.loadString(any())).thenAnswer((_) async => 'invalid json');

      final call = datasource.getPokemons();

      expect(call, throwsA(isA<FileException>()));
    });
  });
}
