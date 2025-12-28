import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/features/pokemons/data/models/pokemon_model.dart';
import 'package:pokedex_serasa/features/pokemons/data/models/pokemon_response_model.dart';

import '../../../../helpers/fixture_reader.dart';

void main() {
  group('PokemonResponseModel', () {
    test('should parse JSON with pokemon array', () {
      final Map<String, dynamic> jsonMap = json.decode(
        fixture('pokemons_response_fixture.json'),
      );

      final result = PokemonResponseModel.fromJson(jsonMap);

      expect(result.pokemon, isA<List<PokemonModel>>());
      expect(result.pokemon.length, 2);
      expect(result.pokemon[0].name, 'Bulbasaur');
      expect(result.pokemon[1].name, 'Ivysaur');
    });

    test('should handle empty pokemon array', () {
      final Map<String, dynamic> jsonMap = {'pokemon': []};

      final result = PokemonResponseModel.fromJson(jsonMap);

      expect(result.pokemon, isEmpty);
    });
  });
}
