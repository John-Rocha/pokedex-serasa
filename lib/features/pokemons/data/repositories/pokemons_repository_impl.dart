import 'package:dartz/dartz.dart';
import 'package:pokedex_serasa/core/errors/exceptions.dart';
import 'package:pokedex_serasa/core/errors/failures.dart';
import 'package:pokedex_serasa/features/pokemons/data/datasources/pokemons_local_datasource.dart';
import 'package:pokedex_serasa/features/pokemons/data/datasources/pokemons_remote_datasource.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';
import 'package:pokedex_serasa/features/pokemons/domain/repositories/pokemons_repository.dart';

class PokemonsRepositoryImpl implements PokemonsRepository {
  final PokemonsRemoteDatasource remoteDatasource;
  final PokemonsLocalDatasource localDatasource;

  const PokemonsRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<Either<Failure, List<Pokemon>>> getPokemons() async {
    try {
      final pokemonModels = await remoteDatasource.getPokemons();
      final pokemons = pokemonModels.map((model) => model.toEntity()).toList();
      return Right(pokemons);
    } on NetworkException {
      try {
        final pokemonModels = await localDatasource.getPokemons();
        final pokemons = pokemonModels
            .map((model) => model.toEntity())
            .toList();
        return Right(pokemons);
      } on FileException catch (e) {
        return Left(FileFailure(message: e.message));
      } catch (e) {
        return Left(
          UnexpectedFailure(
            message: 'Failed to load local data: ${e.toString()}',
          ),
        );
      }
    } catch (e) {
      return Left(
        UnexpectedFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }
}
