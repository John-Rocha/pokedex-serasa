import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_serasa/core/enums/sort_order.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';
import 'package:pokedex_serasa/features/pokemons/domain/usecases/search_pokemon.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemon_search/pokemon_search_state.dart';

class PokemonSearchCubit extends Cubit<PokemonSearchState> {
  final SearchPokemon searchPokemon;
  String _currentQuery = '';
  SortOrder _currentSortOrder = SortOrder.none;
  String? _currentTypeFilter;

  PokemonSearchCubit({
    required this.searchPokemon,
  }) : super(const PokemonSearchInitial());

  SortOrder get currentSortOrder => _currentSortOrder;
  String? get currentTypeFilter => _currentTypeFilter;

  Future<void> search(String query) async {
    _currentQuery = query;

    if (query.isEmpty) {
      emit(const PokemonSearchInitial());
      return;
    }

    emit(const PokemonSearchLoading());

    final result = await searchPokemon(query);

    result.fold(
      (failure) => emit(PokemonSearchError(message: failure.message)),
      (pokemons) {
        final filteredPokemons = _applyFilters(pokemons);

        if (filteredPokemons.isEmpty) {
          emit(PokemonSearchEmpty(query: _currentQuery));
        } else {
          emit(
            PokemonSearchSuccess(
              pokemons: filteredPokemons,
              sortOrder: _currentSortOrder,
              typeFilter: _currentTypeFilter,
            ),
          );
        }
      },
    );
  }

  void applySortOrder(SortOrder sortOrder) {
    _currentSortOrder = sortOrder;

    if (state is PokemonSearchSuccess) {
      final currentState = state as PokemonSearchSuccess;
      final sortedPokemons = _sortPokemons(currentState.pokemons, sortOrder);
      emit(
        PokemonSearchSuccess(
          pokemons: sortedPokemons,
          sortOrder: sortOrder,
          typeFilter: _currentTypeFilter,
        ),
      );
    } else if (_currentQuery.isNotEmpty) {
      search(_currentQuery);
    }
  }

  void applyFilters(SortOrder sortOrder, String? typeFilter) {
    _currentSortOrder = sortOrder;
    _currentTypeFilter = typeFilter;

    if (_currentQuery.isNotEmpty) {
      search(_currentQuery);
    }
  }

  List<Pokemon> _applyFilters(List<Pokemon> pokemons) {
    var result = List<Pokemon>.from(pokemons);

    // Filtro por tipo
    if (_currentTypeFilter != null && _currentTypeFilter!.isNotEmpty) {
      result = result.where((pokemon) {
        return pokemon.type.any(
          (type) => type.toLowerCase() == _currentTypeFilter!.toLowerCase(),
        );
      }).toList();
    }

    // Ordenação
    result = _sortPokemons(result, _currentSortOrder);

    return result;
  }

  List<Pokemon> _sortPokemons(List<Pokemon> pokemons, SortOrder sortOrder) {
    final pokemonsCopy = List<Pokemon>.from(pokemons);

    switch (sortOrder) {
      case SortOrder.alphabetical:
        pokemonsCopy.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOrder.idAscending:
        pokemonsCopy.sort((a, b) => a.id.compareTo(b.id));
        break;
      case SortOrder.idDescending:
        pokemonsCopy.sort((a, b) => b.id.compareTo(a.id));
        break;
      case SortOrder.none:
        // Mantém ordem original
        break;
    }

    return pokemonsCopy;
  }

  void clear() {
    _currentQuery = '';
    _currentSortOrder = SortOrder.none;
    _currentTypeFilter = null;
    emit(const PokemonSearchInitial());
  }
}
