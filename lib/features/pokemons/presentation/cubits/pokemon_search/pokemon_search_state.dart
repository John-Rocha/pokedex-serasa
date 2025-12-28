import 'package:equatable/equatable.dart';
import 'package:pokedex_serasa/core/enums/sort_order.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';

sealed class PokemonSearchState extends Equatable {
  const PokemonSearchState();

  @override
  List<Object?> get props => [];
}

class PokemonSearchInitial extends PokemonSearchState {
  const PokemonSearchInitial();
}

class PokemonSearchLoading extends PokemonSearchState {
  const PokemonSearchLoading();
}

class PokemonSearchSuccess extends PokemonSearchState {
  final List<Pokemon> pokemons;
  final SortOrder sortOrder;
  final String? typeFilter;

  const PokemonSearchSuccess({
    required this.pokemons,
    this.sortOrder = SortOrder.none,
    this.typeFilter,
  });

  @override
  List<Object?> get props => [pokemons, sortOrder, typeFilter];
}

class PokemonSearchEmpty extends PokemonSearchState {
  final String query;

  const PokemonSearchEmpty({
    required this.query,
  });

  @override
  List<Object?> get props => [query];
}

class PokemonSearchError extends PokemonSearchState {
  final String message;

  const PokemonSearchError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
