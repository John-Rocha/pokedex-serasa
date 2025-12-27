import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:pokedex_serasa/core/errors/exceptions.dart';
import 'package:pokedex_serasa/features/pokemons/data/datasources/pokemons_local_datasource.dart';
import 'package:pokedex_serasa/features/pokemons/data/models/pokemon_model.dart';
import 'package:pokedex_serasa/features/pokemons/data/models/pokemon_response_model.dart';

class PokemonsLocalDatasourceImpl implements PokemonsLocalDatasource {
  final AssetBundle assetBundle;

  const PokemonsLocalDatasourceImpl({
    required this.assetBundle,
  });

  @override
  Future<List<PokemonModel>> getPokemons() async {
    try {
      final jsonString = await assetBundle.loadString(
        'assets/resource/pokemons.json',
      );
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final response = PokemonResponseModel.fromJson(jsonData);
      return response.pokemon;
    } catch (e) {
      throw FileException(
        message: 'Failed to load local pokemons data: ${e.toString()}',
      );
    }
  }
}
