import 'package:dartz/dartz.dart';
import 'package:pokedex_serasa/core/errors/failures.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';
import 'package:pokedex_serasa/features/pokemons/domain/repositories/pokemons_repository.dart';

class GetPokemons {
  final PokemonsRepository repository;

  const GetPokemons({
    required this.repository,
  });

  Future<Either<Failure, List<Pokemon>>> call() {
    return repository.getPokemons();
  }
}
