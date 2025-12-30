import 'package:flutter/material.dart';
import 'package:pokedex_serasa/core/utils/pokemon_type_colors.dart';
import 'package:pokedex_serasa/core/widgets/type_badge.dart';
import 'package:pokedex_serasa/features/analytics/presentation/mixins/analytics_mixin.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';
import 'package:pokedex_serasa/features/pokemon_detail/presentation/widgets/pokemon_evolution_chain.dart';
import 'package:pokedex_serasa/features/pokemon_detail/presentation/widgets/pokemon_info_section.dart';
import 'package:pokedex_serasa/features/pokemon_detail/presentation/widgets/pokemon_stats_chart.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/pokemon_header_widget.dart';
import 'package:pokedex_serasa/features/pokemon_detail/presentation/widgets/pokemon_wikeness_widget.dart';

class PokemonDetailPage extends StatefulWidget {
  final Pokemon pokemon;
  final List<Pokemon>? allPokemons;

  const PokemonDetailPage({
    required this.pokemon,
    this.allPokemons,
    super.key,
  });

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage>
    with AnalyticsMixin {
  @override
  String get screenName => 'Pokemon Detail';

  @override
  Widget build(BuildContext context) {
    final primaryType = widget.pokemon.type.isNotEmpty
        ? widget.pokemon.type.first
        : 'normal';
    final typeColor = PokemonTypeColors.getTypeColor(primaryType);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          PokemonHeaderWidget(
            isHomePage: false,
            foregroundColor: typeColor,
            pokemon: widget.pokemon,
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.pokemon.type
                    .map(
                      (type) => TypeBadge(
                        type: type,
                        fontSize: 14,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 24,
                children: [
                  PokemonWikenessWidget(pokemon: widget.pokemon),
                  PokemonStatsChart(pokemon: widget.pokemon),
                  PokemonInfoSection(pokemon: widget.pokemon),
                  if (widget.pokemon.prevEvolution != null ||
                      widget.pokemon.nextEvolution != null)
                    PokemonEvolutionChain(
                      pokemon: widget.pokemon,
                      allPokemons: widget.allPokemons,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
