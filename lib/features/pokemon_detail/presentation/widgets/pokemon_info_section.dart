import 'package:flutter/material.dart';
import 'package:pokedex_serasa/core/theme/app_text_styles.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';

class PokemonInfoSection extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonInfoSection({
    required this.pokemon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Seção de informações do pokémon',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: const Text(
              'Informações',
              style: AppTextStyles.displaySmall,
            ),
          ),
          const SizedBox(height: 16),
          Semantics(
            readOnly: true,
            label: 'Informações gerais: Altura ${pokemon.height}, Peso ${pokemon.weight}, Doce ${pokemon.candy}, ${pokemon.candyCount != null ? 'Doces para evoluir ${pokemon.candyCount}, ' : ''}Ovo ${pokemon.egg}, Chance de spawn ${pokemon.spawnChance.toStringAsFixed(2)}%, Horário de spawn ${pokemon.spawnTime}',
            child: ExcludeSemantics(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Altura', pokemon.height),
                    const Divider(height: 24),
                    _buildInfoRow('Peso', pokemon.weight),
                    const Divider(height: 24),
                    _buildInfoRow('Doce', pokemon.candy),
                    if (pokemon.candyCount != null) ...[
                      const Divider(height: 24),
                      _buildInfoRow('Doces para evoluir', '${pokemon.candyCount}'),
                    ],
                    const Divider(height: 24),
                    _buildInfoRow('Ovo', pokemon.egg),
                    const Divider(height: 24),
                    _buildInfoRow(
                      'Chance de spawn',
                      '${pokemon.spawnChance.toStringAsFixed(2)}%',
                    ),
                    const Divider(height: 24),
                    _buildInfoRow('Horário de spawn', pokemon.spawnTime),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
