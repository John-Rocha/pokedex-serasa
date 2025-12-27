import 'package:equatable/equatable.dart';
import 'package:pokedex_serasa/features/pokemons/data/models/pokemon_model.dart';

class PokemonResponseModel extends Equatable {
  final List<PokemonModel> pokemon;

  const PokemonResponseModel({
    required this.pokemon,
  });

  factory PokemonResponseModel.fromJson(Map<String, dynamic> json) {
    return PokemonResponseModel(
      pokemon: (json['pokemon'] as List<dynamic>)
          .map((e) => PokemonModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [pokemon];
}
