import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_serasa/core/enums/sort_order.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';
import 'package:pokedex_serasa/features/pokemons/domain/usecases/get_pokemons.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemons_list/pokemons_list_state.dart';

class PokemonsListCubit extends Cubit<PokemonsListState> {
  final GetPokemons getPokemons;
  SortOrder _currentSortOrder = SortOrder.none;
  String? _currentTypeFilter;

  PokemonsListCubit({
    required this.getPokemons,
  }) : super(const PokemonsListInitial());

  SortOrder get currentSortOrder => _currentSortOrder;
  String? get currentTypeFilter => _currentTypeFilter;

  Future<void> loadPokemons() async {
    emit(const PokemonsListLoading());

    final result = await getPokemons();

    result.fold(
      (failure) => emit(PokemonsListError(message: failure.message)),
      (pokemons) {
        final filteredPokemons = _applyFilters(pokemons);
        emit(
          PokemonsListSuccess(
            pokemons: filteredPokemons,
            allPokemons: pokemons,
            sortOrder: _currentSortOrder,
            typeFilter: _currentTypeFilter,
          ),
        );
      },
    );
  }

  void applySortOrder(SortOrder sortOrder) {
    _currentSortOrder = sortOrder;

    if (state is PokemonsListSuccess) {
      final currentState = state as PokemonsListSuccess;
      final filteredPokemons = _applyFilters(currentState.allPokemons);
      emit(
        PokemonsListSuccess(
          pokemons: filteredPokemons,
          allPokemons: currentState.allPokemons,
          sortOrder: sortOrder,
          typeFilter: _currentTypeFilter,
        ),
      );
    }
  }

  void applyFilters(SortOrder sortOrder, String? typeFilter) {
    _currentSortOrder = sortOrder;
    _currentTypeFilter = typeFilter;

    if (state is PokemonsListSuccess) {
      final currentState = state as PokemonsListSuccess;
      final filteredPokemons = _applyFilters(currentState.allPokemons);
      emit(
        PokemonsListSuccess(
          pokemons: filteredPokemons,
          allPokemons: currentState.allPokemons,
          sortOrder: sortOrder,
          typeFilter: typeFilter,
        ),
      );
    }
  }

  List<Pokemon> _applyFilters(List<Pokemon> pokemons) {
    var result = List<Pokemon>.from(pokemons);

    if (_currentTypeFilter != null && _currentTypeFilter!.isNotEmpty) {
      result = result.where((pokemon) {
        return pokemon.type.any(
          (type) => type.toLowerCase() == _currentTypeFilter!.toLowerCase(),
        );
      }).toList();
    }

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
        break;
    }

    return pokemonsCopy;
  }

  void clearFilters() {
    _currentSortOrder = SortOrder.none;
    _currentTypeFilter = null;

    if (state is PokemonsListSuccess) {
      final currentState = state as PokemonsListSuccess;
      emit(
        PokemonsListSuccess(
          pokemons: currentState.allPokemons,
          allPokemons: currentState.allPokemons,
          sortOrder: SortOrder.none,
          typeFilter: null,
        ),
      );
    }
  }
}
