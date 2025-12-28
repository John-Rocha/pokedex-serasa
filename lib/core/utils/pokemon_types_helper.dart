import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';

class PokemonTypesHelper {
  static List<String> extractUniqueTypes(List<Pokemon> pokemons) {
    final Set<String> typesSet = {};

    for (final pokemon in pokemons) {
      typesSet.addAll(pokemon.type);
    }

    final types = typesSet.toList();
    types.sort();

    return types;
  }
}
