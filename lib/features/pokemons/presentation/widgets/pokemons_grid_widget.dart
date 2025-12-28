import 'package:flutter/material.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/pokemon_card.dart';

class PokemonGridWidget extends StatelessWidget {
  const PokemonGridWidget({
    required this.pokemons,
    super.key,
  });

  final List<Pokemon> pokemons;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final pokemon = pokemons[index];
            return PokemonCard(
              pokemon: pokemon,
              onTap: () {
                print('Tapped on ${pokemon.name}');
              },
            );
          },
          childCount: pokemons.length,
        ),
      ),
    );
  }
}
