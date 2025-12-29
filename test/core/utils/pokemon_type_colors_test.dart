import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/core/utils/pokemon_type_colors.dart';

void main() {
  group('PokemonTypeColors', () {
    test('should return correct color for fire type', () {
      final color = PokemonTypeColors.getTypeColor('fire');

      expect(color, const Color(0xFFF08030));
    });

    test('should return correct color for water type', () {
      final color = PokemonTypeColors.getTypeColor('water');

      expect(color, const Color(0xFF6890F0));
    });

    test('should return correct color for grass type', () {
      final color = PokemonTypeColors.getTypeColor('grass');

      expect(color, const Color(0xFF78C850));
    });

    test('should return correct color for electric type', () {
      final color = PokemonTypeColors.getTypeColor('electric');

      expect(color, const Color(0xFFF8D030));
    });

    test('should return correct color for psychic type', () {
      final color = PokemonTypeColors.getTypeColor('psychic');

      expect(color, const Color(0xFFF85888));
    });

    test('should return correct color for ice type', () {
      final color = PokemonTypeColors.getTypeColor('ice');

      expect(color, const Color(0xFF98D8D8));
    });

    test('should return correct color for dragon type', () {
      final color = PokemonTypeColors.getTypeColor('dragon');

      expect(color, const Color(0xFF7038F8));
    });

    test('should return correct color for dark type', () {
      final color = PokemonTypeColors.getTypeColor('dark');

      expect(color, const Color(0xFF705848));
    });

    test('should return correct color for fairy type', () {
      final color = PokemonTypeColors.getTypeColor('fairy');

      expect(color, const Color(0xFFEE99AC));
    });

    test('should return correct color for normal type', () {
      final color = PokemonTypeColors.getTypeColor('normal');

      expect(color, const Color(0xFFA8A878));
    });

    test('should return correct color for fighting type', () {
      final color = PokemonTypeColors.getTypeColor('fighting');

      expect(color, const Color(0xFFC03028));
    });

    test('should return correct color for flying type', () {
      final color = PokemonTypeColors.getTypeColor('flying');

      expect(color, const Color(0xFFA890F0));
    });

    test('should return correct color for poison type', () {
      final color = PokemonTypeColors.getTypeColor('poison');

      expect(color, const Color(0xFFA040A0));
    });

    test('should return correct color for ground type', () {
      final color = PokemonTypeColors.getTypeColor('ground');

      expect(color, const Color(0xFFE0C068));
    });

    test('should return correct color for rock type', () {
      final color = PokemonTypeColors.getTypeColor('rock');

      expect(color, const Color(0xFFB8A038));
    });

    test('should return correct color for bug type', () {
      final color = PokemonTypeColors.getTypeColor('bug');

      expect(color, const Color(0xFFA8B820));
    });

    test('should return correct color for ghost type', () {
      final color = PokemonTypeColors.getTypeColor('ghost');

      expect(color, const Color(0xFF705898));
    });

    test('should return correct color for steel type', () {
      final color = PokemonTypeColors.getTypeColor('steel');

      expect(color, const Color(0xFFB8B8D0));
    });

    test('should be case insensitive for type names', () {
      final lowerCase = PokemonTypeColors.getTypeColor('fire');
      final upperCase = PokemonTypeColors.getTypeColor('FIRE');
      final mixedCase = PokemonTypeColors.getTypeColor('FiRe');

      expect(lowerCase, upperCase);
      expect(lowerCase, mixedCase);
    });

    test('should return grey color for unknown type', () {
      final color = PokemonTypeColors.getTypeColor('unknown');

      expect(color, Colors.grey);
    });

    test('should return grey color for empty string', () {
      final color = PokemonTypeColors.getTypeColor('');

      expect(color, Colors.grey);
    });
  });
}
