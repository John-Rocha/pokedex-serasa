import 'package:pokedex_serasa/features/pokemons/data/models/pokemon_model.dart';

abstract class PokemonsLocalDatasource {
  Future<List<PokemonModel>> getPokemons();
}
