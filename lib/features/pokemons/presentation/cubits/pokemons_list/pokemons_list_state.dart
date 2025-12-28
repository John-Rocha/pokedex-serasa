import 'package:equatable/equatable.dart';
import 'package:pokedex_serasa/core/enums/sort_order.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';

sealed class PokemonsListState extends Equatable {
  const PokemonsListState();

  @override
  List<Object?> get props => [];
}

class PokemonsListInitial extends PokemonsListState {
  const PokemonsListInitial();
}

class PokemonsListLoading extends PokemonsListState {
  const PokemonsListLoading();
}

class PokemonsListSuccess extends PokemonsListState {
  final List<Pokemon> pokemons;
  final List<Pokemon> allPokemons;
  final bool isFromLocalSource;
  final SortOrder sortOrder;
  final String? typeFilter;

  const PokemonsListSuccess({
    required this.pokemons,
    required this.allPokemons,
    this.isFromLocalSource = false,
    this.sortOrder = SortOrder.none,
    this.typeFilter,
  });

  @override
  List<Object?> get props => [
    pokemons,
    allPokemons,
    isFromLocalSource,
    sortOrder,
    typeFilter,
  ];
}

class PokemonsListError extends PokemonsListState {
  final String message;

  const PokemonsListError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
