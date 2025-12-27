import 'package:dartz/dartz.dart';
import 'package:pokedex_serasa/core/errors/failures.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';

abstract class PokemonsRepository {
  Future<Either<Failure, List<Pokemon>>> getPokemons();
}
