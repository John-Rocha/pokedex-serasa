import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_pokemon_view_usecase.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/pokemon_card.dart';

class PokemonGridWidget extends StatelessWidget {
  const PokemonGridWidget({
    required this.pokemons,
    this.allPokemons,
    super.key,
  });

  final List<Pokemon> pokemons;
  final List<Pokemon>? allPokemons;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final pokemon = pokemons[index];
            return PokemonCard(
              pokemon: pokemon,
              onTap: () {
                final logPokemonViewUseCase =
                    Modular.get<LogPokemonViewUseCase>();
                logPokemonViewUseCase(
                  pokemonId: pokemon.id,
                  pokemonName: pokemon.name,
                  types: pokemon.type,
                );

                Modular.to.pushNamed(
                  '/pokemon-detail/',
                  arguments: {
                    'pokemon': pokemon,
                    'allPokemons': allPokemons ?? pokemons,
                  },
                );
              },
            );
          },
          childCount: pokemons.length,
        ),
      ),
    );
  }
}
