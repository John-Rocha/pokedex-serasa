import 'package:flutter/material.dart';
import 'package:pokedex_serasa/core/theme/app_text_styles.dart';
import 'package:pokedex_serasa/core/utils/pokemon_type_colors.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';

class PokemonStatsChart extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonStatsChart({
    required this.pokemon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final primaryType = pokemon.type.isNotEmpty ? pokemon.type.first : 'normal';
    final typeColor = PokemonTypeColors.getTypeColor(primaryType);

    final stats = _getStats();
    final statsText = stats
        .map((s) => '${s.label}: ${s.displayValue}')
        .join(', ');

    return Semantics(
      container: true,
      label: 'Seção de estatísticas do pokémon',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: const Text(
              'Estatísticas',
              style: AppTextStyles.displaySmall,
            ),
          ),
          const SizedBox(height: 16),
          Semantics(
            label: 'Gráfico de estatísticas: $statsText',
            child: ExcludeSemantics(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: stats.map((stat) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                stat.label,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                stat.displayValue,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: typeColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: stat.normalizedValue,
                              minHeight: 12,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                typeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<StatData> _getStats() {
    return [
      StatData(
        label: 'Chance de Spawn',
        value: pokemon.spawnChance,
        maxValue: 10.0,
        displayValue: '${pokemon.spawnChance.toStringAsFixed(2)}%',
      ),
      StatData(
        label: 'Média de Spawns',
        value: pokemon.avgSpawns,
        maxValue: 100.0,
        displayValue: pokemon.avgSpawns.toStringAsFixed(1),
      ),
      if (pokemon.multipliers != null && pokemon.multipliers!.isNotEmpty)
        StatData(
          label: 'Multiplicador',
          value: pokemon.multipliers!.first,
          maxValue: 2.0,
          displayValue: pokemon.multipliers!.first.toStringAsFixed(2),
        ),
    ];
  }
}

class StatData {
  final String label;
  final double value;
  final double maxValue;
  final String displayValue;

  StatData({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.displayValue,
  });

  double get normalizedValue => (value / maxValue).clamp(0.0, 1.0);
}
