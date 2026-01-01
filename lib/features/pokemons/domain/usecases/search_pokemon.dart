import 'package:dartz/dartz.dart';
import 'package:pokedex_serasa/core/errors/failures.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';
import 'package:pokedex_serasa/features/pokemons/domain/repositories/pokemons_repository.dart';

class SearchPokemon {
  final PokemonsRepository repository;

  const SearchPokemon({
    required this.repository,
  });

  Future<Either<Failure, List<Pokemon>>> call(String query) async {
    if (query.isEmpty) {
      return const Right([]);
    }

    final result = await repository.getPokemons();

    return result.fold(
      (failure) => Left(failure),
      (pokemons) {
        final filteredPokemons = pokemons.where((pokemon) {
          final nameLower = pokemon.name.toLowerCase();
          final numLower = pokemon.pokeNum.toLowerCase();
          final queryLower = query.toLowerCase().trim();

          return nameLower.contains(queryLower) ||
              numLower.contains(queryLower);
        }).toList();

        return Right(filteredPokemons);
      },
    );
  }
}
