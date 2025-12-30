import 'package:flutter/material.dart';
import 'package:pokedex_serasa/core/theme/app_text_styles.dart';
import 'package:pokedex_serasa/core/widgets/type_badge.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';

class PokemonWikenessWidget extends StatelessWidget {
  const PokemonWikenessWidget({
    required this.pokemon,
    super.key,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final weaknessesText = pokemon.weaknesses.join(', ');

    return Semantics(
      container: true,
      label: 'Seção de fraquezas do pokémon',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          Semantics(
            header: true,
            child: Text(
              'Fraquezas',
              style: AppTextStyles.displaySmall,
            ),
          ),
          Semantics(
            label: 'Fraquezas do pokémon: $weaknessesText',
            child: ExcludeSemantics(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: pokemon.weaknesses
                      .map(
                        (weakness) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TypeBadge(
                            type: weakness,
                            fontSize: 14,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
