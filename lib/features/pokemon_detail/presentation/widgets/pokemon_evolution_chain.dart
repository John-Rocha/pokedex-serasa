import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex_serasa/core/theme/app_text_styles.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_pokemon_view_usecase.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/pokemon_card.dart';

class PokemonEvolutionChain extends StatelessWidget {
  final Pokemon pokemon;
  final List<Pokemon>? allPokemons;

  const PokemonEvolutionChain({
    required this.pokemon,
    this.allPokemons,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final hasEvolutions =
        pokemon.prevEvolution != null || pokemon.nextEvolution != null;

    if (!hasEvolutions) {
      return const SizedBox.shrink();
    }

    return Semantics(
      container: true,
      label: 'Seção de pokémons relacionados',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            header: true,
            child: const Text(
              'Relacionados',
              style: AppTextStyles.displaySmall,
            ),
          ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (pokemon.prevEvolution != null)
              ...pokemon.prevEvolution!.map(
                (evolution) {
                  final relatedPokemon = allPokemons?.firstWhere(
                    (p) => p.num == evolution.num,
                  );
                  if (relatedPokemon == null) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      height: 200,
                      child: PokemonCard(
                        pokemon: relatedPokemon,

                        onTap: () {
                          final logPokemonViewUseCase =
                              Modular.get<LogPokemonViewUseCase>();
                          logPokemonViewUseCase(
                            pokemonId: relatedPokemon.id,
                            pokemonName: relatedPokemon.name,
                            types: relatedPokemon.type,
                          );

                          Navigator.of(context).pushNamed(
                            '/pokemon-detail/',
                            arguments: {
                              'pokemon': relatedPokemon,
                              'allPokemons': allPokemons,
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            if (pokemon.nextEvolution != null)
              ...pokemon.nextEvolution!.map(
                (evolution) {
                  final relatedPokemon = allPokemons?.firstWhere(
                    (p) => p.num == evolution.num,
                  );
                  if (relatedPokemon == null) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      height: 200,
                      child: PokemonCard(
                        pokemon: relatedPokemon,

                        onTap: () {
                          final logPokemonViewUseCase =
                              Modular.get<LogPokemonViewUseCase>();
                          logPokemonViewUseCase(
                            pokemonId: relatedPokemon.id,
                            pokemonName: relatedPokemon.name,
                            types: relatedPokemon.type,
                          );

                          Navigator.of(context).pushNamed(
                            '/pokemon-detail/',
                            arguments: {
                              'pokemon': relatedPokemon,
                              'allPokemons': allPokemons,
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ],
      ),
    );
  }
}
