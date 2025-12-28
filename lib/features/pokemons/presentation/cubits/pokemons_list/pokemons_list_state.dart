import 'package:equatable/equatable.dart';
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
  final bool isFromLocalSource;

  const PokemonsListSuccess({
    required this.pokemons,
    this.isFromLocalSource = false,
  });

  @override
  List<Object?> get props => [pokemons, isFromLocalSource];
}

class PokemonsListError extends PokemonsListState {
  final String message;

  const PokemonsListError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
