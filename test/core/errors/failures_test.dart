import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/core/errors/failures.dart';

void main() {
  group('NetworkFailure', () {
    const tMessage = 'Network error occurred';

    test('should have correct message', () {
      const failure = NetworkFailure(message: tMessage);

      expect(failure.message, tMessage);
    });

    test('should extend Failure', () {
      const failure = NetworkFailure(message: tMessage);

      expect(failure, isA<Failure>());
    });

    test('should support value equality', () {
      const failure1 = NetworkFailure(message: tMessage);
      const failure2 = NetworkFailure(message: tMessage);
      const failure3 = NetworkFailure(message: 'Different message');

      expect(failure1, failure2);
      expect(failure1, isNot(failure3));
    });

    test('should have correct props', () {
      const failure = NetworkFailure(message: tMessage);

      expect(failure.props, [tMessage]);
    });
  });

  group('FileFailure', () {
    const tMessage = 'File not found';

    test('should have correct message', () {
      const failure = FileFailure(message: tMessage);

      expect(failure.message, tMessage);
    });

    test('should extend Failure', () {
      const failure = FileFailure(message: tMessage);

      expect(failure, isA<Failure>());
    });

    test('should support value equality', () {
      const failure1 = FileFailure(message: tMessage);
      const failure2 = FileFailure(message: tMessage);
      const failure3 = FileFailure(message: 'Different message');

      expect(failure1, failure2);
      expect(failure1, isNot(failure3));
    });

    test('should have correct props', () {
      const failure = FileFailure(message: tMessage);

      expect(failure.props, [tMessage]);
    });
  });

  group('UnexpectedFailure', () {
    const tMessage = 'Unexpected error occurred';

    test('should have correct message', () {
      const failure = UnexpectedFailure(message: tMessage);

      expect(failure.message, tMessage);
    });

    test('should extend Failure', () {
      const failure = UnexpectedFailure(message: tMessage);

      expect(failure, isA<Failure>());
    });

    test('should support value equality', () {
      const failure1 = UnexpectedFailure(message: tMessage);
      const failure2 = UnexpectedFailure(message: tMessage);
      const failure3 = UnexpectedFailure(message: 'Different message');

      expect(failure1, failure2);
      expect(failure1, isNot(failure3));
    });

    test('should have correct props', () {
      const failure = UnexpectedFailure(message: tMessage);

      expect(failure.props, [tMessage]);
    });
  });

  group('Different Failure Types', () {
    const tMessage = 'Same message';

    test('different failure types should not be equal even with same message', () {
      const networkFailure = NetworkFailure(message: tMessage);
      const fileFailure = FileFailure(message: tMessage);
      const unexpectedFailure = UnexpectedFailure(message: tMessage);

      expect(networkFailure, isNot(fileFailure));
      expect(networkFailure, isNot(unexpectedFailure));
      expect(fileFailure, isNot(unexpectedFailure));
    });
  });
}
