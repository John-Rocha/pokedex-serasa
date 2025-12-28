import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemons_list/pokemons_list_cubit.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemons_list/pokemons_list_state.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/error_display_widget.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/pokemon_header_widget.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/loading_widget.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/pokemons_grid_widget.dart';

class PokemonsListPage extends StatefulWidget {
  const PokemonsListPage({super.key});

  @override
  State<PokemonsListPage> createState() => _PokemonsListPageState();
}

class _PokemonsListPageState extends State<PokemonsListPage> {
  final PokemonsListCubit _cubit = Modular.get<PokemonsListCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.loadPokemons();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const PokemonHeaderWidget(),
          BlocBuilder<PokemonsListCubit, PokemonsListState>(
            bloc: _cubit,
            builder: (context, state) {
              return switch (state) {
                PokemonsListInitial() ||
                PokemonsListLoading() => SliverFillRemaining(
                  child: LoadingWidget(),
                ),
                PokemonsListSuccess(:final pokemons) => PokemonGridWidget(
                  pokemons: pokemons,
                ),
                PokemonsListError() => SliverFillRemaining(
                  child: ErrorDisplayWidget(
                    message: state.message,
                    onRetry: () => _cubit.loadPokemons(),
                  ),
                ),
              };
            },
          ),
        ],
      ),
    );
  }
}
