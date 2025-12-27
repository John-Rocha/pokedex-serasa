import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_serasa/features/pokemons/domain/usecases/get_pokemons.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemons_list/pokemons_list_state.dart';

class PokemonsListCubit extends Cubit<PokemonsListState> {
  final GetPokemons getPokemons;

  PokemonsListCubit({
    required this.getPokemons,
  }) : super(const PokemonsListInitial());

  Future<void> loadPokemons() async {
    emit(const PokemonsListLoading());

    final result = await getPokemons();

    result.fold(
      (failure) => emit(PokemonsListError(message: failure.message)),
      (pokemons) => emit(PokemonsListSuccess(pokemons: pokemons)),
    );
  }
}
