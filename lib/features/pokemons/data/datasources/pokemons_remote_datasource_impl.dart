import 'package:dio/dio.dart';
import 'package:pokedex_serasa/core/errors/exceptions.dart';
import 'package:pokedex_serasa/core/network/dio_client.dart';
import 'package:pokedex_serasa/features/pokemons/data/datasources/pokemons_remote_datasource.dart';
import 'package:pokedex_serasa/features/pokemons/data/models/pokemon_model.dart';
import 'package:pokedex_serasa/features/pokemons/data/models/pokemon_response_model.dart';

class PokemonsRemoteDatasourceImpl implements PokemonsRemoteDatasource {
  final RestClient restClient;

  const PokemonsRemoteDatasourceImpl({
    required this.restClient,
  });

  @override
  Future<List<PokemonModel>> getPokemons() async {
    try {
      final response = await restClient.get('/pokedex.json');
      final responseModel = PokemonResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return responseModel.pokemon;
    } on DioException catch (e) {
      throw NetworkException(
        message: 'Failed to fetch pokemons from API: ${e.message}',
      );
    } catch (e) {
      throw NetworkException(
        message: 'Unexpected error occurred: ${e.toString()}',
      );
    }
  }
}
