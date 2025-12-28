import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/core/errors/exceptions.dart';

void main() {
  group('PokemonException', () {
    const tMessage = 'Test exception message';

    test('should create exception with message', () {
      const exception = PokemonException(message: tMessage);

      expect(exception.message, tMessage);
    });

    test('toString should return the message', () {
      const exception = PokemonException(message: tMessage);

      expect(exception.toString(), tMessage);
    });

    test('should be an instance of Exception', () {
      const exception = PokemonException(message: tMessage);

      expect(exception, isA<Exception>());
    });
  });

  group('NetworkException', () {
    const tMessage = 'Network error occurred';

    test('should create exception with message', () {
      const exception = NetworkException(message: tMessage);

      expect(exception.message, tMessage);
    });

    test('should extend PokemonException', () {
      const exception = NetworkException(message: tMessage);

      expect(exception, isA<PokemonException>());
      expect(exception, isA<Exception>());
    });

    test('toString should return the message', () {
      const exception = NetworkException(message: tMessage);

      expect(exception.toString(), tMessage);
    });
  });

  group('FileException', () {
    const tMessage = 'File not found';

    test('should create exception with message', () {
      const exception = FileException(message: tMessage);

      expect(exception.message, tMessage);
    });

    test('should extend PokemonException', () {
      const exception = FileException(message: tMessage);

      expect(exception, isA<PokemonException>());
      expect(exception, isA<Exception>());
    });

    test('toString should return the message', () {
      const exception = FileException(message: tMessage);

      expect(exception.toString(), tMessage);
    });
  });
}
